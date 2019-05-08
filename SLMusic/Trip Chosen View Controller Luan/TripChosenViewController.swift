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
    
    
    var departureStationForChosenTrip: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(departureStationForChosenTrip ?? "No departure name")")
        guard let depName = departureStationForChosenTrip else {
            print("Something went wrong")
            return
            
        }
        
        departureStationForChosenTripLabel.text = depName
    }
    
    @IBAction func startChosenTripButton(_ sender: UIButton) {
    }
    
}
