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
}
