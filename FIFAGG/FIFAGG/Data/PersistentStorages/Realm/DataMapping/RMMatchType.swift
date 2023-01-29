//
//  RMMatchType.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2023/01/29.
//

import Foundation
import RealmSwift

final class RMMatchType: Object {
    @Persisted(primaryKey: true) var objectID: String = ""
    @Persisted var matchtype: Int = 0
    @Persisted var desc: String = ""
}

extension RMMatchType: RealmResponseType {
    
    func asResponse() -> MatchtypeDTO {
        return MatchtypeDTO(matchtype: matchtype, desc: desc)
    }
}
