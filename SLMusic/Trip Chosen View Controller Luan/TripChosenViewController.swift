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
    
    let genres = ["Pop", "Rock", "Rap", "Country", "Latin"]
    
    var selectedGenre: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    @IBAction func startChosenTripButton(_ sender: UIButton) {
        performSegue(withIdentifier: "goToMusic", sender: self)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genres.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genres[row]
    }
    
    func getRadioStations() {
        
        
        
    }
    
    
}
