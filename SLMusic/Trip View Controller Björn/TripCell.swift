//
//  TripCell.swift
//  SLMusic
//
//  Created by Björn Åhström on 2019-04-30.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation
import UIKit

class TripCell: UITableViewCell {
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var departureStationLabel: UILabel!
    @IBOutlet weak var tripLenghtLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var arrivalStationLabel: UILabel!
    
    func setLabelsTo(currentTimeLabel: String, departureTimeLabel: String, departureStationLabel: String, tripLenghtLabel: String, arrivalTimeLabel: String, arrivalStationLabel: String) {
        
        self.currentTimeLabel.text = currentTimeLabel
        self.departureTimeLabel.text = departureTimeLabel
        self.departureStationLabel.text = departureStationLabel
        self.tripLenghtLabel.text = tripLenghtLabel
        self.arrivalTimeLabel.text = arrivalTimeLabel
        self.arrivalStationLabel.text = arrivalStationLabel
    }
    
}
