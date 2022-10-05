//
//  SpidDTO.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/09/08.
//

import Foundation

struct SpidDTO: Decodable {
    let id: Int
    let name: String
    var objectID: String = ""
}

extension SpidDTO: RealmRepresentable {
    func asRealm() -> RMSpid {
        return RMSpid.build { object in
            object.id = self.id
            object.name = self.name
            object.objectID = objectID
        }
    }
}
