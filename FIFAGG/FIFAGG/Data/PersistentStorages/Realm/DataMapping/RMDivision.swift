//
//  RMDivision.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2023/02/07.
//

import Foundation
import RealmSwift

final class RMDivision: Object {
    @Persisted(primaryKey: true) var objectID: String = ""
    @Persisted var divisionId: Int
    @Persisted var divisionName: String
}

extension RMDivision: RealmResponseType {
    
    func asResponse() -> DivisionDTO {
        return DivisionDTO(
            divisionId: self.divisionId,
            divisionName: self.divisionName
        )
    }
}
