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
    
    var areaNumber: Int = 9192
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tripTableView.dataSource = self
        tripTableView.delegate = self
        
        guard let urlString = URL(string: "http://api.sl.se/api2/realtimedeparturesV4.json?key=c40fe26f05b647a484397437b6aadbd9&siteid=\(areaNumber)&timewindow=10") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: urlString) { (data, response, error) in
            if let response = response {
                print("Response \(response)")
            }

            if let data = data {
                do {
                    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                        if let buses = json["Buses"] as? [String : Any] {
                            if let destination = buses["Destination"] as? [String : Any] {
                                print("!!!!!!!!!! \(destination)")
                            }
                        }
//                    print("!!!!!!!! \(json)")
//
//                    guard let buses = json as? [Any] else { return }
//
//                    for information in buses {
//                        guard let info = information as? [String : Any] else { return }
//                        guard let stopArea = info["StopAreaName"] as? String else { return }
//
//                        print("!!!!!!!!! \(stopArea)")
                    }

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
