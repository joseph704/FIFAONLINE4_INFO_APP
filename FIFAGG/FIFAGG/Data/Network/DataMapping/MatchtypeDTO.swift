//
//  MatchtypeDTO.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2023/01/29.
//

import Foundation

struct MatchtypeDTO: Decodable {
    let matchtype: Int
    let desc: String
    var objectID: String {
        get {
            return String(matchtype)
        }
    }
}

extension MatchtypeDTO: RealmRepresentable {
    func asRealm() -> RMMatchType {
        return RMMatchType.build { object in
            object.matchtype = self.matchtype
            object.desc = self.desc
            object.objectID = objectID
        }
    }
}
