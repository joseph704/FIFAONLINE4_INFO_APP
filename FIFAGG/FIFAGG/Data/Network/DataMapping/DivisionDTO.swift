//
//  DivisionDTO.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2023/02/07.
//

import Foundation

struct DivisionDTO: Decodable {
    let divisionId: Int
    let divisionName: String
    var objectID: String {
        get {
            return String(divisionId)
        }
    }
}

extension DivisionDTO: RealmRepresentable {
    func asRealm() -> RMDivision {
        return RMSPPostion.build { object in
            object.divisionId = self.divisionId
            object.divisionName = self.divisionName
            object.objectID = self.objectID
        }
    }
}
