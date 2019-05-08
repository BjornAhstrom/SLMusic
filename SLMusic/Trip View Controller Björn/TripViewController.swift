//
//  TripViewController.swift
//  SLMusic
//
//  Created by Björn Åhström on 2019-04-30.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Alamofire

class TripViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tripTableView: UITableView!
    
    private let SLReseplanerare3_1 = "f8087c9e88564b9f9a53e74a2c37eae5"
    private let tripChosenViewControllerId = "tripChosenViewController"
    private let goToSelectedTripId = "goToSelectedTrip"
    
    var fromSiteId: String?
    var toSiteId: String?
    var departureStationForChosenTripToPass: String?
    var departureTimeForChosenTripToPass: String?
    var arrivalStationForChosenTripToPass: String?
    var arrivalTimeForChosenTripToPass: String?
    
    var fromDest: Int?
    var toDest: Int?
    
//    var cityTransportationDeparture = [CityTransportationStop]()
//    var cityTransportationArrival = [CityTransportationStop]()
    
    var departure = [Departure]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Odenplan: 9117, Solna: 9305
        fromDest = Int(fromSiteId ?? "9117")
        toDest = Int(toSiteId ?? "9305")
        
        tripTableView.dataSource = self
        tripTableView.delegate = self
        
        //Slussen: 9192, Alvik: 9112
        getDepartureDataFromSL(from: toDest ?? 9192, to: fromDest ?? 9112)
        tripTableView.reloadData()
    }
    
    //    func getDepartureDataFromJourney(refId: String){
    //        let journey = "https://api.sl.se/api2/TravelplannerV3_1/journeydetail.json?key=\(SLReseplanerare3_1)&id=\(refId)"
    //
    //        guard let url = URL(string: journey) else { return }
    //
    //        URLSession.shared.dataTask(with: url) { (data, response, error) in
    //            guard let data = data else { return }
    //            do {
    //                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { return }
    //
    //                guard let stops = json["Stops"] as? [String : Any] else { return }
    //                guard let stop = stops["Stop"] as? [[String : Any]] else { return }
    //
    //                for s in stop {
    //                    let cityTransportation = CityTransportationStop(json: s)
    //                    self.cityTransportationArrival.append(cityTransportation)
    //
    //                    DispatchQueue.main.async {
    //                        self.tripTableView.reloadData()
    //                    }
    //                }
    //            } catch let jsonError {
    //                print("Error serializing json:", jsonError)
    //            }
    //            }.resume()
    //    }
    
    func getDepartureDataFromSL(from: Int, to: Int) {
        guard let trip =                                                                                                     URL(string:"https://api.sl.se/api2/TravelplannerV3_1/trip.json?key=\(SLReseplanerare3_1)&lang=se&originExtId=\(from)&destExtId=\(to)&maxChange=3&lines=!19") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: trip) { (data, response, error) in
            if let response = response {
                print("Response \(response)")
            }
            
            if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { return }
                    
                    guard let trips = json["Trip"] as? [[String : Any ]] else { return }
                    
                    for trip in trips {
                        guard let legList = trip["LegList"] as? [String : Any] else { return }
                        guard let leg = legList["Leg"] as? [[String : Any]] else { return }
                        
                        for leg in leg {
                            guard let origin = leg["Origin"] as? [String : Any] else { return }
                            guard let dest = leg["Destination"] as? [String : Any] else { return}
                            
                            let de = Departure(start: EndPoint.init(json: origin), end: EndPoint.init(json: dest))
                            self.departure.append(de)
                            
                            guard let journeyDetailRef = leg["JourneyDetailRef"] as? [String : Any] else { return }
                            guard let refId = journeyDetailRef["ref"] as? String else { return }
                            let aString = refId
                            let newString = aString.replacingOccurrences(of: "|", with: "%7C", options: .literal, range: nil)
                            //self.getDepartureDataFromJourney(refId: newString)
                            DispatchQueue.main.async {
                                self.tripTableView.reloadData()
                            }
                        }
                    }
                } catch {
                    self.alertMessage(titel: "Something went wrong", message: "\(error.localizedDescription )")
                    print(error)
                }
                
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            }.resume()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath) as? TripCell
        
        let dep = departure[indexPath.row]
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        let depName = dep.start.name
        let arrName = dep.end.name
        cell?.currentTimeLabel.text = dateString
        cell?.departureStationLabel.text = "Från \(depName ?? "No departure")"
        cell?.departureTimeLabel.text = "\(dep.start.time ?? "00:00")"
        cell?.arrivalStationLabel.text = "Till \(arrName ?? "No destination")"
        cell?.arrivalTimeLabel.text = "\(dep.end.time ?? "00:00")"
        
        let endTimeString = dep.end.time
        let endStationTime = endTimeString?.split(separator: ":")
        let endHoursString = endStationTime?[0] ?? "00"
        let endMinutesString = endStationTime?[1] ?? "00"
        let endSecondsString = endStationTime?[2] ?? "00"
        
        
        let endHoursInt = Int(endHoursString) ?? 0
        let endMinutesInt = Int(endMinutesString) ?? 0
        let endSecondsInt = Int(endSecondsString) ?? 0
        
        let endStaionTime = (endHoursInt * 60) + (endMinutesInt) + (endSecondsInt / 60)
        
        let startTimeString = dep.start.time
        let startStationTime = startTimeString?.split(separator: ":")
        let startHoursString = startStationTime?[0] ?? "00"
        let startMinutesString = startStationTime?[1] ?? "00"
        let startSecondsString = startStationTime?[2] ?? "00"
        
        let startHoursInt = Int(startHoursString) ?? 0
        let startMinutesInt = Int(startMinutesString) ?? 0
        let startSecondsInt = Int(startSecondsString) ?? 0
        
        let startStaionTime = (startHoursInt * 60) + (startMinutesInt) + (startSecondsInt / 60)
        
        let travelLenght = endStaionTime - startStaionTime
        
        cell?.tripLenghtLabel.text = "Restid \(travelLenght) min"
        return cell ?? cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let tripCell = tableView.cellForRow(at: indexPath) as? TripCell else {
            print("Tripcell fail")
            return
        }
        
        departureStationForChosenTripToPass = tripCell.departureStationLabel.text
        departureTimeForChosenTripToPass = tripCell.departureTimeLabel.text
        arrivalStationForChosenTripToPass = tripCell.arrivalStationLabel.text
        arrivalTimeForChosenTripToPass = tripCell.arrivalTimeLabel.text
        
        performSegue(withIdentifier: goToSelectedTripId, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == goToSelectedTripId {
            if let destination = segue.destination as? TripChosenViewController {
                guard let depName = departureStationForChosenTripToPass else {
                    print("Something went wrong, no departure name")
                    return }
                
                destination.departureStationForChosenTrip = depName
                //                destination.departureTimeForChosenTripLabel
                //                destination.arrivalStationForChosenTripLabel
                //                destination.arrivalTimeForChosenTripLabel
            }
        }
    }
}

extension UIViewController {
    func alertMessage(titel: String, message: String) {
        let alert = UIAlertController(title: titel, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion:  nil)
    }
}
