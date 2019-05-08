//
//  TripChosenViewController.swift
//  SLMusic
//
//  Created by Luan Nguyen on 2019-05-02.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Alamofire

class TripChosenViewController: UIViewController {

    @IBOutlet weak var departureTimeForChosenTripLabel: UILabel!
    @IBOutlet weak var departureStationForChosenTripLabel: UILabel!
    
    @IBOutlet weak var arrivalTimeForChosenTripLabel: UILabel!
    @IBOutlet weak var arrivalStationForChosenTripLabel: UILabel!
    
    @IBOutlet weak var tripChosenTimeLabel: UILabel!
    
    @IBOutlet weak var musicGenrePickerWheel: UIPickerView!
    
    //VARIABLES RECEIVED BY BJORN
    var departureStation: String?
    var departureTime: String?
    var arrivalStation: String?
    var arrivalTime: String?
    var tripLength: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func startChosenTripButton(_ sender: UIButton) {
    }
    
}
