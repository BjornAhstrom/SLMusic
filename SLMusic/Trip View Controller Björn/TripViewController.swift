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
    
    var areaNumber: Int = 9192
    var metrosData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tripTableView.dataSource = self
        tripTableView.delegate = self
        getDataFromSL()
        
        
    }
    
    func getDataFromSL() {
        print("!!!!!!!!!!!!!!!!!!!!Data from sl")
        
        guard let trip = URL(string:"https://api.sl.se/api2/TravelplannerV3_1/trip.json?key=\(SLReseplanerare3_1)&lang=se&originExtId=TCE&destExtId=9192&maxChange=3&lines=!19") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: trip) { (data, response, error) in
            if let response = response {
                print("Response \(response)")
            }
            
            if let data = data {
                do {
                    
                    
                    
                    print("!!!!!!!! START 1")
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { return }
                    
                    //print("!!!!!\(json)")
                    
                    let trips = json["Trip"] as! [[String : Any ]]
                    let trip = trips[2]
                    let legList = trip["LegList"] as! [String : Any]
                    let leg = legList["Leg"] as! [[String : Any]]
                    let legs = leg[0]
                    let journeyDetailRef = legs["JourneyDetailRef"] as! [String : Any]
                    let refId = journeyDetailRef["ref"] as! String
                    
                    
                    //                    let buses = responseData["JourneyDetailRef"] as! [[String : Any]]
                    //                    let bus = buses[0]
                    //                    let dest = bus["ref"] as! String
                    let aString = refId
                    let newString = aString.replacingOccurrences(of: "|", with: "%7C", options: .literal, range: nil)
                    
                    //print("!!!!!\(newString)")
                    self.getDataFromTrip(refId: newString)
                    
                    
                } catch {
                    print(error)
                }
                
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            }.resume()
    }
    
    func getDataFromTrip(refId: String) {
        print("!!!!!!!!!!!!!!!!!!!!Get data from trip")
        guard let journey = URL(string: "https://api.sl.se/api2/TravelplannerV3_1/journeydetail.json?key=\(SLReseplanerare3_1)&id=\(refId)") else { return }
        
        
        let session = URLSession.shared
        session.dataTask(with: journey) { (data, response, error) in
            if let response = response {
                print("Response \(response)")
            }
            
            if let data = data {
                do {
                    
                    
                    
                    print("!!!!!!!! START 2")
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { return }
                    
                    print("!!!!!\(json)")
                    
                    guard let stops = json["Stops"] as? [String : Any ] else { return }
                    guard let stop = stops["Stop"] as? [[String : Any]] else { return }
                    let firstStop = stop[0]
                    guard let name = firstStop["name"] as? String else { return }
                    guard let depTime = firstStop["rtDepTime"] as? String else { return }
                    
                    print("!!!!! \(name)")
                    print("!!!!! \(depTime)")
                    
                    
                    
                } catch {
                    print(error)
                }
                
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            }.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath) as? TripCell
        
        
        
        return cell ?? cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
}
