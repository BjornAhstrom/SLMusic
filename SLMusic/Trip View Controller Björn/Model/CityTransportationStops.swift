//
//  CityTransportationStops.swift
//  SLMusic
//
//  Created by Björn Åhström on 2019-05-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation

class CityTransportationStops {
    var cityTransportationStops: [String : Any]
    
    init(json: [String : Any]) {
        cityTransportationStops = json["Stops"] as? [String : Any] ?? [:]
    }
}
