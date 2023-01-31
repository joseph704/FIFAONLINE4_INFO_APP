//
//  SPPostionDTO.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2023/02/01.
//

import Foundation

struct SPPostionDTO: Decodable {
    let spPosition: Int
    let desc: String
    var objectID: String {
        get {
            return String(spPosition)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case spPosition = "spposition"
        case desc
    }
}

extension SPPostionDTO: RealmRepresentable {
    func asRealm() -> RMSPPostion {
        return RMSPPostion.build { object in
            object.spPosition = self.spPosition
            object.desc = self.desc
            object.objectID = self.objectID
        }
    }
}
