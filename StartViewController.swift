//
//  StartViewController.swift
//  SLMusic
//
//  Created by joakim lundberg on 2019-04-29.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

//Sök på restiden för playlisten

import UIKit
import Alamofire

class StartViewController: UIViewController {
    
    @IBOutlet weak var fromStation: UITextField!
    @IBOutlet weak var toStation: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var search: UIButton!
    
    //let stations = ["Abrahamsberg": "Abb",
    //   "Akalla": "Aka","Alby": "Alb","Alvik": "Alv","Aspudden": "Asu","Axelsberg": "Axb","Bagarmossen": "Bam","Bandhagen": "Bah",]
    
    var toStationName = ""
    var fromStationName = ""
    var toStationRef = ""
    var fromStationRed = ""
    var siteID = ""
    var siteID2 = ""
    var departureTime = NSDate()

    override func viewDidLoad() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        
        let startStation = fromStation.text!
        let endStation = toStation.text!
        let departureTime = timePicker.date
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToResult"  {
            if let destination = segue.destination as? TripViewController {
                destination.siteID = siteID
                destination.siteID2 = siteID2
                destination.departureTime = departureTime
                
            }
        }
    }
    @IBAction func searchTrip(_ sender: UIButton) {
        print("timepicker-------------")
        print(timePicker.date)
        
        print("Searching trip")
        fromStationName = fromStation.text!
        toStationName = toStation.text!
        
        guard let trip = URL(string: "https://api.sl.se/api2/typeahead.json?key=ca35ed126dfa42c69bef67cb1c3ba5df&searchstring=\(fromStationName)&stationsonly=true&maxresults=1") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: trip) { (data, response, error) in
            if let response = response {
                //print("Response \(response)")
            }
            if let data = data {
                do {
                    
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { return }
                    
                    guard let responseData = json["ResponseData"] as? [[String : Any]] else { return }
                    let test = responseData[0]
                    guard let siteId = test["SiteId"] as? String else { return }
                    
                    print("start id 1 \(siteId)")
                    
                } catch {
                    print(error)
                }
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            }.resume()
        
        guard let trip2 = URL(string: "https://api.sl.se/api2/typeahead.json?key=ca35ed126dfa42c69bef67cb1c3ba5df&searchstring=\(toStationName)&stationsonly=true&maxresults=1") else { return }
        
        let session2 = URLSession.shared
        session.dataTask(with: trip2) { (data, response, error) in
            if let response = response {
                //print("Response \(response)")
            }
            if let data = data {
                do {
                    
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { return }
                    
                    guard let responseData = json["ResponseData"] as? [[String : Any]] else { return }
                    let test = responseData[0]
                    guard let siteId2 = test["SiteId"] as? String else { return }
                    
                    print("slut id 2 \(siteId2)")
                    
                } catch {
                    print(error)
                }
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            }.resume()
        
    }
}
