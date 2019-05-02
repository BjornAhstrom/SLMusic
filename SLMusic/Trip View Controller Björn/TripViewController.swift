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
    
    var test: [String:Any] = [:]
    var areaNumber: Int = 9192
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tripTableView.dataSource = self
        tripTableView.delegate = self
        
        guard let url = URL(string: "http://api.sl.se/api2/realtimedeparturesV4.json?key=c40fe26f05b647a484397437b6aadbd9&siteid=\(areaNumber)&timewindow=10") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("!!!!!!!! \(json)")
                } catch {
                    print(error)
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
        
//        let destination = UIViewController() as? TripViewController // Ska bytas ut när luan har skapat sin klass
//        navigationController?.pushViewController(destination!, animated: true)
    }

}
