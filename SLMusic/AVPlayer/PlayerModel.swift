//
//  PlayerModel.swift
//  SLMusic
//
//  Created by Ivan Ignatkov on 2019-05-14.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation
import UIKit

class PlayerModel {
    var image: String?
    var name: String?
    
    init(json: [String: Any]) {
        image = json["image"] as? String ?? ""
        name = json["name"] as? String ?? ""
    }
}
