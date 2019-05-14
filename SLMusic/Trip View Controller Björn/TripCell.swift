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
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var departureStationLabel: UILabel!
    @IBOutlet weak var travelTimeLabel: UILabel!
    @IBOutlet weak var tripLenghtLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var arrivalStationLabel: UILabel!
    
    private var timer = Timer()
    
    func setLabelsTo(currentTimeLabel: String, departureTimeLabel: String, departureStationLabel: String, tripLenghtLabel: String, arrivalTimeLabel: String, arrivalStationLabel: String) {
        
        self.currentTimeLabel.text = currentTimeLabel
        self.departureTimeLabel.text = departureTimeLabel
        self.departureStationLabel.text = departureStationLabel
        self.tripLenghtLabel.text = tripLenghtLabel
        self.arrivalTimeLabel.text = arrivalTimeLabel
        self.arrivalStationLabel.text = arrivalStationLabel
    }
    
    func updateclock() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TripCell.updateClockInLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateClockInLabel() {
        let cell = self
        var currentTime = cell.currentTimeLabel.text
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = Date()
        currentTime = dateFormatter.string(from: date)
        
        cell.currentTimeLabel.text = currentTime
    }
}
