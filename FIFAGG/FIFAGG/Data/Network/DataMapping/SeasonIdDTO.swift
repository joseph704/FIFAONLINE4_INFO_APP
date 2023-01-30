//
//  SeasonIdDTO.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2023/01/30.
//

import Foundation

struct SeasonIdDTO: Decodable {
    let seasonId: Int
    let className: String
    let seasonImageURL: String
    var objectID: String {
        get {
            return String(seasonId)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case seasonId
        case className
        case seasonImageURL = "seasonImg"
    }
}

extension SeasonIdDTO: RealmRepresentable {
    func asRealm() -> RMSeasonId {
        return RMSeasonId.build { object in
            object.seasonId = self.seasonId
            object.className = self.className
            object.seasonImageURL = self.seasonImageURL
            object.objectID = self.objectID
        }
    }
}
