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
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var fromSiteId: String?
    var toSiteId: String?
    var departureStationForChosenTripToPass: String?
    var departureTimeForChosenTripToPass: String?
    var arrivalStationForChosenTripToPass: String?
    var arrivalTimeForChosenTripToPass: String?
    var tripChosenTimeLengthToPass: String?
    var fontOnTextInLabels: String = "Arial"
    
    var fromDest: Int?
    var toDest: Int?
    
    var departure = [Departure]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopActivityIndicator()
        
        // Odenplan: 9117, Solna: 9305
        fromDest = Int(fromSiteId ?? "9117")
        toDest = Int(toSiteId ?? "9305")
        
        tripTableView.dataSource = self
        tripTableView.delegate = self
        
        //Slussen: 9192, Alvik: 9112
        getDepartureAndArrivalDataFromSL(from: toDest ?? 9192, to: fromDest ?? 9112)
        tripTableView.reloadData()
    }
    
    // MARK: Start activity indicator
    func startActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    // MARK: Stop activity indicator
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    // MARK: Get departure and arrival data (siteId) from StartViewController
    func getDepartureAndArrivalDataFromSL(from: Int, to: Int) {
        startActivityIndicator()
        
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
                            
                            let dep = Departure(start: EndPoint.init(json: origin), end: EndPoint.init(json: dest))
                            self.departure.append(dep)
                            
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
    
    // MARK: Convert time from string to an int, and then convert hours to minutes
    func travelTimeLengtConverter(startTime: String, endTime: String) -> Int {
        var travelLenght: Int = 0
        
        let startTimeString = startTime
        let startStationTime = startTimeString.split(separator: ":")
        let startHoursString = startStationTime[0]
        let startMinutesString = startStationTime[1]
        let startSecondsString = startStationTime[2]
        
        let startHoursInt = Int(startHoursString) ?? 0
        let startMinutesInt = Int(startMinutesString) ?? 0
        let startSecondsInt = Int(startSecondsString) ?? 0
        
        let startStaionTime = (startHoursInt * 60) + (startMinutesInt) + (startSecondsInt / 60)
        
        let endTimeString = endTime
        let endStationTime = endTimeString.split(separator: ":")
        let endHoursString = endStationTime[0]
        let endMinutesString = endStationTime[1]
        let endSecondsString = endStationTime[2]
        
        let endHoursInt = Int(endHoursString) ?? 0
        let endMinutesInt = Int(endMinutesString) ?? 0
        let endSecondsInt = Int(endSecondsString) ?? 0
        
        let endStaionTime = (endHoursInt * 60) + (endMinutesInt) + (endSecondsInt / 60)
        
        travelLenght = endStaionTime - startStaionTime
        
        return travelLenght
    }
    
    // MARK: Remove seconds and keep hours and minutes from the time (12:00:00 to 12:00)
    func convertString(time: String) -> String {
        var newTime: String
        let convertTime = time.index(time.startIndex, offsetBy: 5)
        let convertedTime = time[..<convertTime]
        newTime = String(convertedTime)
        
        return newTime
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath) as? TripCell
        
        self.stopActivityIndicator()
        
        let dep = departure[indexPath.row]
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        let depName = dep.start.name
        let arrName = dep.end.name
        
        cell?.departureLabel.font = UIFont(name: fontOnTextInLabels, size: 20)
        cell?.departureLabel.textColor = UIColor(named: "SLBlue")
        
        cell?.arrivalLabel.font = UIFont(name: fontOnTextInLabels, size: 20)
        cell?.arrivalLabel.textColor = UIColor(named: "SLBlue")
        
        cell?.currentTimeLabel.font = UIFont(name: fontOnTextInLabels, size: 20)
        cell?.currentTimeLabel.textColor = UIColor(named: "SLBlue")
        cell?.currentTimeLabel.text = dateString
        
        cell?.departureStationLabel.text = "\(depName ?? "No departure")"
        cell?.departureStationLabel.font = UIFont(name: fontOnTextInLabels, size: 14)
        
        let departureTime = convertString(time: dep.start.time ?? "00:00")
        cell?.departureTimeLabel.text = "\(departureTime)"
        cell?.departureTimeLabel.font = UIFont(name: fontOnTextInLabels, size: 20)
        
        cell?.arrivalStationLabel.text = "\(arrName ?? "No destination")"
        cell?.arrivalStationLabel.font = UIFont(name: fontOnTextInLabels, size: 14)
        
        let arrivalTime = convertString(time: dep.end.time ?? "00:00")
        cell?.arrivalTimeLabel.text = "\(arrivalTime)"
        cell?.arrivalTimeLabel.font = UIFont(name: fontOnTextInLabels, size: 20)
        
        cell?.travelTimeLabel.font = UIFont(name: fontOnTextInLabels, size: 18)
        
        let travelLenght = travelTimeLengtConverter(startTime: dep.start.time ?? "00", endTime: dep.end.time ?? "00")
        cell?.tripLenghtLabel.text = "\(travelLenght)"
        cell?.tripLenghtLabel.font = UIFont(name: fontOnTextInLabels, size: 18)
        
        cell?.minLabel.font = UIFont(name: fontOnTextInLabels, size: 18)
        
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
        tripChosenTimeLengthToPass = tripCell.tripLenghtLabel.text
        
        performSegue(withIdentifier: goToSelectedTripId, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == goToSelectedTripId {
            if let destination = segue.destination as? TripChosenViewController {
                
                guard let arrName = arrivalStationForChosenTripToPass else { return }
                guard let arrTime = arrivalTimeForChosenTripToPass else { return }
                guard let depName = departureStationForChosenTripToPass else { return }
                guard let depTime = departureTimeForChosenTripToPass else { return }
                guard let travelLength = tripChosenTimeLengthToPass else { return }
                
                destination.arrivalStationForChosenTrip = arrName
                destination.arrivalTimeForChosenTrip = arrTime
                destination.departureStationForChosenTrip = depName
                destination.departureTimeForChosenTrip = depTime
                destination.tripChosenTimeLength = travelLength
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
