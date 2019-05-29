//
//  StartViewController.swift
//  SLMusic
//
//  Created by joakim lundberg on 2019-04-29.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

//Sök på restiden för playlisten

import UIKit

class StartViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fromStation: UITextField!
    @IBOutlet weak var toStation: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var search: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        
        fromStation.delegate = self
        toStation.delegate = self
        timePicker.isHidden = true
        hideKeyboardWhenTappedAround()
        
        super.viewDidLoad()
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        fromStation.resignFirstResponder()
        toStation.resignFirstResponder()
        
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == fromStation) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 150), animated: true)
        } else if (textField == toStation) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 220), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == fromStation) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        } else if (textField == toStation) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }
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
        self.startActivityIndicator(activityIndicator: activityIndicator)
        
        fromStationName = fromStation.text!
        toStationName = toStation.text!
        
        
        if fromStationName == "" || toStationName == "" {
            let alert = UIAlertController(title: "Error", message: "Du måste fylle i ett stationsnamn!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Stäng", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
        
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
                    
                    for respons in responseData {
                        guard let id = respons["SiteId"] as? String else { return }
                        self.siteID2 = id
                    }
                    
                    print("david start id 1 \(self.siteID)")
                    if self.siteNameLookupDone {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "goToResult", sender: self)
                            self.fromStation.text = ""
                            self.toStation.text = ""
                            self.stopActivityIndicator(activityIndicator: self.activityIndicator)
                            
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
                print("Response \(response)")
            }
            if let data = data {
                do {
                    
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { return }
                    
                    guard let responseData = json["ResponseData"] as? [[String : Any]] else { return }
                    
                    for respons in responseData {
                        guard let id = respons["SiteId"] as? String else { return }
                        self.siteID = id
                        print("david slut id 2 \(self.siteID2)")
                    }
                    
                    print("david slut id 2 \(self.siteID2)")
                    
                    if self.siteNameLookupDone {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "goToResult", sender: self)
                            self.fromStation.text = ""
                            self.toStation.text = ""
                            self.stopActivityIndicator(activityIndicator: self.activityIndicator)
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
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
