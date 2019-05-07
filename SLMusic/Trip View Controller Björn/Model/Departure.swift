//
//  Departure.swift
//  SLMusic
//
//  Created by Björn Åhström on 2019-05-06.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation

class Departure {
    var start: EndPoint
    var end: EndPoint
    
    init(start: EndPoint, end: EndPoint) {
        self.start = start
        self.end = end
    }
    
    
    
    
    
    
    
//    var depName: String?
//    var depType: String?
//    var depId: String?
//    var depExtId: String?
//    var depLon: Int?
//    var depLat: Int?
//    var depPrognosisType: String?
//    var depTime: String?
//    var depDate: String?
//    var depRtTime: String?
//    var depRtDate: String?
//    var depHasMainMast: Bool?
//    var depMainMastId: String?
//    var depMainMastExtId: String?
//
//    var arrName: String?
//    var arrType: String?
//    var arrId: String?
//    var arrExtId: String?
//    var arrLon: Int?
//    var arrLat: Int?
//    var arrPrognosisType: String?
//    var arrTime: String?
//    var arrDate: String?
//    var arrRtTime: String?
//    var arrRtDate: String?
//    var arrHasMainMast: Bool?
//    var arrMainMastId: String?
//    var arrMainMastExtId: String?
//
//
//    init(depJson: [String : Any], arrJson: [String : Any]) {
//        depName = depJson["name"] as? String ?? ""
//        depType = depJson["type"] as? String ?? ""
//        depId = depJson["id"] as? String ?? ""
//        depExtId = depJson["extId"] as? String ?? ""
//        depLon = depJson["lon"] as? Int ?? -1
//        depLat = depJson["lat"] as? Int ?? -1
//        depPrognosisType = depJson["prognosisType"] as? String ?? ""
//        depTime = depJson["time"] as? String ?? ""
//        depDate = depJson["date"] as? String ?? ""
//        depRtTime = depJson["rtTime"] as? String ?? ""
//        depRtDate = depJson["rtDate"] as? String ?? ""
//        depHasMainMast = depJson["hasMainMast"] as? Bool ?? false
//        depMainMastId = depJson["mainMastId"] as? String ?? ""
//        depMainMastExtId = depJson["mainMastExtId"] as? String ?? ""
//
//        arrName = arrJson["name"] as? String ?? ""
//        arrType = arrJson["type"] as? String ?? ""
//        arrId = arrJson["id"] as? String ?? ""
//        arrExtId = arrJson["extId"] as? String ?? ""
//        arrLon = arrJson["lon"] as? Int ?? -1
//        arrLat = arrJson["lat"] as? Int ?? -1
//        arrPrognosisType = arrJson["prognosisType"] as? String ?? ""
//        arrTime = arrJson["time"] as? String ?? ""
//        arrDate = arrJson["date"] as? String ?? ""
//        arrRtTime = arrJson["rtTime"] as? String ?? ""
//        arrRtDate = arrJson["rtDate"] as? String ?? ""
//        arrHasMainMast = arrJson["hasMainMast"] as? Bool ?? false
//        arrMainMastId = arrJson["mainMastId"] as? String ?? ""
//        arrMainMastExtId = arrJson["mainMastExtId"] as? String ?? ""
//    }
    
//    init(arrJson: [String : Any]) {
//        arrName = arrJson["name"] as? String ?? ""
//        arrType = arrJson["type"] as? String ?? ""
//        arrId = arrJson["id"] as? String ?? ""
//        arrExtId = arrJson["extId"] as? String ?? ""
//        arrLon = arrJson["lon"] as? Int ?? -1
//        arrLat = arrJson["lat"] as? Int ?? -1
//        arrPrognosisType = arrJson["prognosisType"] as? String ?? ""
//        arrTime = arrJson["time"] as? String ?? ""
//        arrDate = arrJson["date"] as? String ?? ""
//        arrRtTime = arrJson["rtTime"] as? String ?? ""
//        arrRtDate = arrJson["rtDate"] as? String ?? ""
//        arrHasMainMast = arrJson["hasMainMast"] as? Bool ?? false
//        arrMainMastId = arrJson["mainMastId"] as? String ?? ""
//        arrMainMastExtId = arrJson["mainMastExtId"] as? String ?? ""
//    }
}
