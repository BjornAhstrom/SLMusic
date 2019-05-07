//
//  Origin.swift
//  SLMusic
//
//  Created by Björn Åhström on 2019-05-06.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation

class Departure {
    var name: String?
    var type: String?
    var id: String?
    var extId: String?
    var lon: Int?
    var lat: Int?
    var prognosisType: String?
    var time: String?
    var date: String?
    var rtTime: String?
    var rtDate: String?
    var hasMainMast: Bool?
    var mainMastId: String?
    var mainMastExtId: String?
    
    init(json: [String : Any]) {
        name = json["name"] as? String ?? ""
        type = json["type"] as? String ?? ""
        id = json["id"] as? String ?? ""
        extId = json["extId"] as? String ?? ""
        lon = json["lon"] as? Int ?? -1
        lat = json["lat"] as? Int ?? -1
        prognosisType = json["prognosisType"] as? String ?? ""
        time = json["time"] as? String ?? ""
        date = json["date"] as? String ?? ""
        rtTime = json["rtTime"] as? String ?? ""
        rtDate = json["rtDate"] as? String ?? ""
        hasMainMast = json["hasMainMast"] as? Bool ?? false
        mainMastId = json["mainMastId"] as? String ?? ""
        mainMastExtId = json["mainMastExtId"] as? String ?? ""
    }
}
