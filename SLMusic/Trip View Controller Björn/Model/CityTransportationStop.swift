//
//  CityTransportation.swift
//  SLMusic
//
//  Created by Björn Åhström on 2019-05-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation

class CityTransportationStop: Decodable {
    var name: String?
    var id: String?
    var extId: String?
    var routeIdx: Int?
    var lon: Int?
    var lat: Int?
    var arrPrognosisType: String?
    var depPrognosisType: String?
    var depTime: String?
    var depDate: String?
    var arrTime: String?
    var arrDate: String?
    var arrTrack: String?
    var depTrack: String?
    var rtDepTime: String?
    var rtDepDate: String?
    var rtArrTime: String?
    var rtArrDate: String?
    var cancelled: Bool?
    var hasMainMast: Bool?
    var mainMastId: String?
    var mainMastExtId: String?
    var rtBoarding: Bool?
    
    
//    init(depDate: String, depTime: String, depTrack: String, name: String, rtDepDate: String, rtDepTime: String) {
//        self.depDate = depDate
//        self.depTime = depTime
//        self.depTrack = depTrack
//        self.name = name
//        self.rtDepDate = rtDepDate
//        self.rtDepTime = rtDepTime
//    }
    
    init(json: [String : Any]) {
        name = json["name"] as? String ?? ""
        id = json["id"] as? String ?? ""
        extId = json["extId"] as? String ?? ""
        routeIdx = json["routeIdx"] as? Int ?? -1
        lon = json["lon"] as? Int ?? -1
        lat = json["lat"] as? Int ?? -1
        arrPrognosisType = json["arrPrognosisType"] as? String ?? ""
        depPrognosisType = json["depPrognosisType"] as? String ?? ""
        depTime = json["depTime"] as? String ?? ""
        depDate = json["depDate"] as? String ?? ""
        arrTime = json["arrTime"] as? String ?? ""
        arrDate = json["arrDate"] as? String ?? ""
        arrTrack = json["arrTrack"] as? String ?? ""
        depTrack = json["depTrack"] as? String ?? ""
        rtDepTime = json["rtDepTime"] as? String ?? ""
        rtDepDate = json["rtDepDate"] as? String ?? ""
        rtArrTime = json["rtArrTime"] as? String ?? ""
        rtArrDate = json["rtArrDate"] as? String ?? ""
        cancelled = json["cancelled"] as? Bool ?? false
        hasMainMast = json["hasMainMast"] as? Bool ?? false
        mainMastId = json["mainMastId"] as? String ?? ""
        mainMastExtId = json["mainMastExtId"] as? String ?? ""
        rtBoarding = json["rtBoarding"] as? Bool ?? false
    }
    
}
