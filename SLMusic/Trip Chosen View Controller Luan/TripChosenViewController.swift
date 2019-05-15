//
//  TripChosenViewController.swift
//  SLMusic
//
//  Created by Luan Nguyen on 2019-05-02.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Alamofire

class TripChosenViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  

    @IBOutlet weak var departureTimeForChosenTripLabel: UILabel!
    @IBOutlet weak var departureStationForChosenTripLabel: UILabel!
    @IBOutlet weak var arrivalTimeForChosenTripLabel: UILabel!
    @IBOutlet weak var arrivalStationForChosenTripLabel: UILabel!
    @IBOutlet weak var tripChosenTimeLabel: UILabel!
    @IBOutlet weak var musicGenrePickerWheel: UIPickerView!
    
    var arrivalStationForChosenTrip: String?
    var arrivalTimeForChosenTrip: String?
    var departureStationForChosenTrip: String?
    var departureTimeForChosenTrip: String?
    var tripChosenTimeLength: String?
    
    var radioChannels = [Channels]()
    
    var selectedGenre: String?
    var idToIvan: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAPI()
        
        guard let arrNam = arrivalStationForChosenTrip else { return }
        guard let arrTime = arrivalTimeForChosenTrip else { return }
        guard let depName = departureStationForChosenTrip else { return }
        guard let depTime = departureTimeForChosenTrip else { return }
        guard let travelTimeLength = tripChosenTimeLength else { return }
        
        arrivalStationForChosenTripLabel.text = arrNam
        arrivalTimeForChosenTripLabel.text = arrTime
        departureStationForChosenTripLabel.text = depName
        departureTimeForChosenTripLabel.text = depTime
        tripChosenTimeLabel.text = travelTimeLength
        musicGenrePickerWheel.dataSource = self
        musicGenrePickerWheel.delegate = self
        
    }
    
    
    @IBAction func startChosenTripButton(_ sender: UIButton) {
        performSegue(withIdentifier: "goToMusic", sender: self)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return radioChannels.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return radioChannels[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("???????????????\(row)")
        guard let id = radioChannels[row].id else {return}
        idToIvan = id
        
    }
    
    func getAPI() {
        print("Starting Request")
        guard let radioURL = URL(string: "http://api.sr.se/api/v2/channels/index?format=json&indent=true") else {return}
        let session = URLSession.shared
        session.dataTask(with: radioURL) { (data, response, error) in
            print("Request activated")
        if let response = response {
            print("Print \(response)")
        }
        if let data = data {
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {return}
                
                print(json)
                print("Successful API request")
                guard let channels = json["channels"] as? [[String: Any]] else {return}
                for items in channels {
                    let channelss = Channels(json: items)
                    self.radioChannels.append(channelss)
                    print("Channels added \(channelss)" )
                }
               
                
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        
        }.resume()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMusic" {
            guard let destVC = segue.destination as?  AVPLayerVC else {return}
            destVC.luanURL = idToIvan
            destVC.luanTime = tripChosenTimeLength
        }
    }
    
    
}
