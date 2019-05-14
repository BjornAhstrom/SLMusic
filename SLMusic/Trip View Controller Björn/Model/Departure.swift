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
    var info: Info
    
    init(start: EndPoint, end: EndPoint, info: Info) {
        self.start = start
        self.end = end
        self.info = info
    }
}
