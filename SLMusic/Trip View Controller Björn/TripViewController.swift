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
    
    private var SLReseplanerare3_1 = "f8087c9e88564b9f9a53e74a2c37eae5"
    
    var fromSiteId: String?
    var toSiteId: String?
    
    var fromDest: Int?
    var toDest: Int?
    
    var cityTransportationDeparture = [CityTransportationStop]() // Avgång
    var cityTransportationArrival = [CityTransportationStop]() // Ankomst
    
    var departure = [Departure]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fromDest = Int(fromSiteId ?? "-1")
        toDest = Int(toSiteId ?? "-1")
        
        tripTableView.dataSource = self
        tripTableView.delegate = self
        //getArrivalDataFromSL()
        
        //slussen: 9192, Alvik: 9112, odenplan: 9117, solna: 9305
        getDepartureDataFromSL(from: toDest ?? 9192, to: fromDest ?? 9112)
        tripTableView.reloadData()
    }
    
    func getDepartureDataFromJourney(refId: String){
        print("!!!!!!!!!!!!!!!!!!!!Get data from journey")
        
        let journey = "https://api.sl.se/api2/TravelplannerV3_1/journeydetail.json?key=\(SLReseplanerare3_1)&id=\(refId)"
        
        guard let url = URL(string: journey) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            //            let dataAsString = String(data: data, encoding: .utf8)
            //              print(dataAsString)
            
            do {
                //                let stops = try JSONDecoder().decode([CityTransportationStops].self, from: data)
                //                print(stops)
                
                //                let cityTransportations = try JSONDecoder().decode([CityTransportationStop].self, from: data)
                //                print("!!!!!!!!!!!! \(cityTransportations)")
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { return }
                //let cityTransportations = CityTransportationStops(json: json)
                guard let stops = json["Stops"] as? [String : Any] else { return }
                guard let stop = stops["Stop"] as? [[String : Any]] else { return }
                
                for s in stop {
                    let cityTransportation = CityTransportationStop(json: s)
                    self.cityTransportationArrival.append(cityTransportation)
                    //print(cityTransportation.name, cityTransportation.depTime)
                    DispatchQueue.main.async {
                        self.tripTableView.reloadData()
                    }
                }
                //let test = stop[3]
                //print("!!!!!!!!!!!! \(cityTransportation.name ?? "")")
                
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
            }.resume()
    }
    
    func getDepartureDataFromSL(from: Int, to: Int) {
        print("!!!!!!!!!!!!!!!!!!!!Departure Data from sl")
        //slussen9192 9112 oden9117 solna9305
        guard let trip =                                                                                                     URL(string:"https://api.sl.se/api2/TravelplannerV3_1/trip.json?key=\(SLReseplanerare3_1)&lang=se&originExtId=\(from)&destExtId=\(to)&maxChange=3&lines=!19") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: trip) { (data, response, error) in
            if let response = response {
                print("Response \(response)")
            }
            
            if let data = data {
                do {
                    print("!!!!!!!! Departure Data from sl")
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { return }
                    
                    //print("!!!!!\(json)")
                    
                    guard let trips = json["Trip"] as? [[String : Any ]] else { return }
                    
                    for trip in trips {
                        guard let legList = trip["LegList"] as? [String : Any] else { return }
                        guard let leg = legList["Leg"] as? [[String : Any]] else { return }
                        
                        for leg in leg {
                            guard let origin = leg["Origin"] as? [String : Any] else { return }
                            guard let dest = leg["Destination"] as? [String : Any] else { return}
                            //                            print("!!!!!!!!! \(origin)")
                            //                            print("!!!!!!!!! \(dest)")
                            //                            let or = Departure(arrJson: origin)
                            //                            self.departure.append(or)
                            let de = Departure(start: EndPoint.init(json: origin), end: EndPoint.init(json: dest))
                            self.departure.append(de)
                            //                            let o = CityTransportationStop(json: origin)
                            //                            self.cityTransportationDeparture.append(o)
                            
                            guard let journeyDetailRef = leg["JourneyDetailRef"] as? [String : Any] else { return }
                            guard let refId = journeyDetailRef["ref"] as? String else { return }
                            let aString = refId
                            let newString = aString.replacingOccurrences(of: "|", with: "%7C", options: .literal, range: nil)
                            self.getDepartureDataFromJourney(refId: newString)
                            print("!!!!!\(newString)")
                            DispatchQueue.main.async {
                                self.tripTableView.reloadData()
                            }
                        }
                    }
                    
                    //                    guard let trips = json["Trip"] as? [[String : Any ]] else { return }
                    //                    let trip = trips[2]
                    //                    guard let legList = trip["LegList"] as? [String : Any] else { return }
                    //                    guard let leg = legList["Leg"] as? [[String : Any]] else { return }
                    //                    let legs = leg[0]
                    //                    guard let journeyDetailRef = legs["JourneyDetailRef"] as? [String : Any] else { return }
                    //                    guard let refId = journeyDetailRef["ref"] as? String else { return }
                    
                    //                    let buses = responseData["JourneyDetailRef"] as! [[String : Any]]
                    //                    let bus = buses[0]
                    //                    let dest = bus["ref"] as! String
                    //                    let aString = refId
                    //                    let newString = aString.replacingOccurrences(of: "|", with: "%7C", options: .literal, range: nil)
                    //
                    //                    print("!!!!!\(newString)")
                    
                    //self.getDeparturelDataFromJourney(refId: newString)
                    
                    
                } catch {
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
        
        let depString = "\(dep.start.time ?? "")"
        let dString = depString
        let newDepString = dString.replacingOccurrences(of: ":", with: "", options: .literal, range: nil)
        let myInt1 = Int(newDepString) ?? 0
        
        let arrString = "\(dep.end.time ?? "")"
        let aString = arrString
        let newArrString = aString.replacingOccurrences(of: ":", with: "", options: .literal, range: nil)
        let myInt2 = Int(newArrString) ?? 0
        
        let tripLenght = (myInt2 - myInt1) / 100
        cell?.tripLenghtLabel.text = "Restid, \(tripLenght) min"
        return cell ?? cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
}
