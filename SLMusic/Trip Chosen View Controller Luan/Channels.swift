//
//  Channels.swift
//  SLMusic
//
//  Created by Luan Nguyen on 2019-05-14.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation


class Channels {
    var id: Int?
    var name: String?
    
    init(json: [String: Any]) {
        id = json["id"] as? Int ?? 164
        name = json["name"] as? String ?? ""
    }
}
