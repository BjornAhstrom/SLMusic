//
//  TripChosenViewController.swift
//  SLMusic
//
//  Created by Luan Nguyen on 2019-05-02.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class TripChosenViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Du får ändra om allt som du vill ha det.  Mvh Björn :)
        
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
    }
    
    @IBAction func startChosenTripButton(_ sender: UIButton) {
    }
    
}
