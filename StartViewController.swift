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
    
    let stations = ["Abrahamsberg","Akalla","Alby","Alvik","Aspudden","Axelsberg","Bagarmossen","Bandhagen","Bergshamra","Björkhagen","Blackeberg", "Blåsut", "Bredäng",    "Brommaplan",  "Danderyds sjukhus","Duvbo", "Enskede gård", "Farsta", "Farsta strand", "Fittja", "Fridhemsplan", "Fridhemsplan", "Fruängen", "Gamla stan", "Globen", "Gubbängen", "Gullmarsplan", "Gärdet", "Hagsätra", "Hallonbergen", "Hallunda", "Hammarbyhöjden", "Hjulsta", "Hornstull", "Husby", "Huvudsta", "Hägerstensåsen", "Hässelby gård", "Hässelby strand","Högdalen","Hökarängen","Hötorget","Islandstorget","Johannelund","Karlaplan","Kista","Kristineberg","Kungsträdgården","Kärrtorp","Liljeholmen","Mariatorget","Masmo","Medborgarplatsen","Midsommarkransen","Mälarhöjden","Mörby centrum","Norsborg","Näckrosen","Odenplan","Rinkeby","Rissne","Ropsten","Råcksta","Rådhuset","Rådmansgatan","Rågsved","S:t Eriksplan","Sandsborg","Skanstull","Skarpnäck","Skogskyrkogården","Skärholmen","Skärmarbrink","Slussen","Sockenplan","Solna centrum","Stadion","Stadshagen","Stora mossen","Stureby","Sundbybergs centrum","Svedmyra","Sätra","T-Centralen","Tallkrogen","Tekniska högskolan","Telefonplan","Tensta","Thorildsplan","Universitetet","Vreten","Vårberg","Vårby gård","Vällingby","Västertorp","Västra skogen","Zinkensdamm","Åkeshov","Ängbyplan","Örnsberg","Östermalmstorg", "test1", "test"]
    
    var toStationName = ""
    var fromStationName = ""
    var toStationRef = ""
    var fromStationRed = ""
    var siteID = ""
    var siteID2 = ""
    var departureTime = NSDate()
    var stationExists = false
    var i = 0
    
    var siteNameLookupDone = false
    
    override func viewDidLoad() {
        
        //http://api.sl.se/api2/realtimedeparturesv4.json?key=01d6897342ce40b0a5ded8df798389e7&siteid=9192&timewindow=5
        
        
        AF.request("http://api.sl.se/api2/TravelplannerV3_1/trip.json?key=5cd013f40caa4e44b9c7efea27a974a0&originId=9192&destId=9112&searchForArrival=0").responseJSON { response in
            switch response.result {
            case .success(let json):
                print(json)
            case .failure(let error):
                print(error)
            }
        }
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult"  {
            if let destination = segue.destination as? TripViewController {
                print("david : \(siteID) \(siteID2) ")
                destination.fromSiteId = self.siteID
                destination.toSiteId = self.siteID2
                // destination.departureTime = departureTime
                
            }
        }
    }
    
    @IBAction func searchTrip(_ sender: UIButton) {
        for station in stations{
            if fromStation.text?.lowercased() == station.lowercased() {
                stationExists = true
            }
        
            DispatchQueue.main.async {
                self.fromStation.text = ""
                self.toStation.text = ""
            }
        }
        
        if fromStation.text == "" || toStation.text == "" || stationExists == false {
            let alert = UIAlertController(title: "Error", message: "Du måste fylle i stationsnamn som finns!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Stäng", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
        
        if stationExists == true{
            
            print("timepicker-------------")
            print(timePicker.date)
            
            print("Searching trip")
            fromStationName = fromStation.text!
            toStationName = toStation.text!
            
            guard let trip = URL(string: "https://api.sl.se/api2/typeahead.json?key=ca35ed126dfa42c69bef67cb1c3ba5df&searchstring=\(fromStationName)&stationsonly=true&maxresults=1") else { return }
            
            let session = URLSession.shared
            session.dataTask(with: trip) { (data, response, error) in
                if let response = response {
                    print("Response \(response)")
                }
                if let data = data {
                    do {
                        
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { return }
                        
                        guard let responseData = json["ResponseData"] as? [[String : Any]] else { return }
                        
                        let test = responseData[0]
                        self.siteID2 = test["SiteId"] as! String
                        
                        print("david start id 1 \(self.siteID)")
                        if self.siteNameLookupDone {
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "goToResult", sender: self)
                            }
                        } else {
                            self.siteNameLookupDone = true
                        }
                        
                        
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
            session2.dataTask(with: trip2) { (data, response, error) in
                if let response = response {
                    // print("Response \(response)")
                }
                if let data = data {
                    do {
                        
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { return }
                        
                        guard let responseData = json["ResponseData"] as? [[String : Any]] else { return }
                        let test = responseData[0]
                        self.siteID = test["SiteId"] as! String
                        
                        print("david slut id 2 \(self.siteID2)")
                        
                        if self.siteNameLookupDone {
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "goToResult", sender: self)
                            }
                        
                        } else {
                            self.siteNameLookupDone = true
                        }
                    } catch {
                        print(error)
                    }
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
                }.resume()
            
            for station in self.stations {
                if self.toStation.text!.lowercased() == station.lowercased() {
                    self.stationExists = true
                }   // goToResult, searchTrip
            }
        }
    }
}
