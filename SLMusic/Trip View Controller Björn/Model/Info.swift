//
//  Info.swift
//  SLMusic
//
//  Created by Björn Åhström on 2019-05-13.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation

class Info {
    var name: String?
    var num: String?
    var line: String?
    var catOut: String?
    var catIn: String?
    var catCode: String?
    var catOutS: String?
    var catOutL: String?
    var operatorCode: String?
    var operators: String?
    var admin: String?
    
    init(json: [String : Any]) {
        name = json["name"] as? String ?? ""
        num = json["num"] as? String ?? ""
        line = json["line"] as? String ?? ""
        catOut = json["catOut"] as? String ?? ""
        catIn = json["catIn"] as? String ?? ""
        catCode = json["catCode"] as? String ?? ""
        catOutS = json["catOutS"] as? String ?? ""
        catOutL = json["catOutL"] as? String ?? ""
        operatorCode = json["operatorCode"] as? String ?? ""
        operators = json["operator"] as? String ?? ""
        admin = json["admin"] as? String ?? ""
    }
    
}
