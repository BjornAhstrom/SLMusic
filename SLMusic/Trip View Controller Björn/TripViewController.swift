//
//  TripViewController.swift
//  SLMusic
//
//  Created by Björn Åhström on 2019-04-30.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class TripViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tripTableView: UITableView!
    
    private let SLReseplanerare3_1 = "f8087c9e88564b9f9a53e74a2c37eae5"
    private let tripChosenViewControllerId = "tripChosenViewController"
    private let goToSelectedTripId = "goToSelectedTrip"
    private var departure = [Departure]()
    
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
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stopActivityIndicator(activityIndicator: activityIndicator)
        
        //Slussen: 9192, Alvik: 9112
        fromDest = Int(fromSiteId ?? "9112")
        toDest = Int(toSiteId ?? "9192")
        
        tripTableView.dataSource = self
        tripTableView.delegate = self
        
        getDepartureAndArrivalDataFromSL(from: toDest ?? 9192, to: fromDest ?? 9112)
    }
    
    // MARK: Get departure and arrival data (siteId) from StartViewController
    func getDepartureAndArrivalDataFromSL(from: Int, to: Int) {
        self.startActivityIndicator(activityIndicator: activityIndicator)
        
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
                        
                        for legs in leg {
                            guard let origin = legs["Origin"] as? [String : Any] else { return }
                            guard let dest = legs["Destination"] as? [String : Any] else { return}
                            guard let info = legs["Product"] as? [String : Any] else { return }
                            
                            let dep = Departure(start: EndPoint.init(json: origin), end: EndPoint.init(json: dest), info: Info.init(json: info))
                            self.departure.append(dep)
                            
                            DispatchQueue.main.async {
                                self.tripTableView.reloadData()
                            }
                        }
                    }
                    
                } catch {
                    self.alertMessage(titel: "Something went wrong", message: "\(error.localizedDescription )")
                }
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            }.resume()
    }
    
    // MARK: Convert text from string to an int, and calculate hours, minutes and seconds to minutes and return value
    func convertFromStringToInt(time: String) -> Int {
        var newTimeValue: Int = 0
        
        let startTimeString = time
        let startStationTime = startTimeString.split(separator: ":")
        let startHoursString = startStationTime[0]
        let startMinutesString = startStationTime[1]
        let startSecondsString = startStationTime[2]
        
        let startHoursInt = Int(startHoursString) ?? 0
        let startMinutesInt = Int(startMinutesString) ?? 0
        let startSecondsInt = Int(startSecondsString) ?? 0
        
        newTimeValue = (startHoursInt * 60) + (startMinutesInt) + (startSecondsInt / 60)
        
        return newTimeValue
    }
    
    // MARK: Calculate start and end time to show the lenght of the trip
    func calculateTravelTime(startTime: Int, endTime: Int) -> Int {
        var travelLength: Int = 0
        
        travelLength = endTime - startTime
        
        return travelLength
    }
    
    // MARK: Remove seconds and keep hours and minutes from the time (12:00:00 to 12:00)
    func convertString(time: String) -> String {
        var newTime: String
        let convertTime = time.index(time.startIndex, offsetBy: 5)
        let convertedTime = time[..<convertTime]
        newTime = String(convertedTime)
        
        return newTime
    }
    
    func currentTime() -> String {
        var currentTime: String
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = Date()
        currentTime = dateFormatter.string(from: date)
        
        return currentTime
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
        
        let depName = dep.start.name
        let arrName = dep.end.name
        let currTime = currentTime()
        
        cell?.departureLabel.font = UIFont(name: fontOnTextInLabels, size: 20)
        cell?.departureLabel.textColor = UIColor(named: "SLBlue")
        
        cell?.arrivalLabel.font = UIFont(name: fontOnTextInLabels, size: 20)
        cell?.arrivalLabel.textColor = UIColor(named: "SLBlue")
        
        cell?.currentTimeLabel.font = UIFont(name: fontOnTextInLabels, size: 20)
        cell?.currentTimeLabel.textColor = UIColor(named: "SLBlue")
        cell?.currentTimeLabel.text = currTime
        cell?.updateclock()
        
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
        
        let startTime = convertFromStringToInt(time: dep.start.time ?? "00")
        let endTime = convertFromStringToInt(time: dep.end.time ?? "00")
        let travelLenght = calculateTravelTime(startTime: startTime, endTime: endTime)
        
        cell?.tripLenghtLabel.text = "\(travelLenght)"
        cell?.tripLenghtLabel.font = UIFont(name: fontOnTextInLabels, size: 18)
        
        cell?.minLabel.font = UIFont(name: fontOnTextInLabels, size: 18)
        let vehicle: String = "\(dep.info.catOutL ?? "No vehicle")"
        cell?.minLabel.text = "min, \(vehicle)"
        
        self.stopActivityIndicator(activityIndicator: activityIndicator)
        
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
    
    // MARK: Start activity indicator
    func startActivityIndicator(activityIndicator: UIActivityIndicatorView ) {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    // MARK: Stop activity indicator
    func stopActivityIndicator(activityIndicator: UIActivityIndicatorView ) {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
