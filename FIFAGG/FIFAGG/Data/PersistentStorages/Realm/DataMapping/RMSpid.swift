//
//  RMSpid.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/09/27.
//

import Foundation
import RealmSwift

final class RMSpid: Object {
    @Persisted(primaryKey: true) var objectID: String = ""
    @Persisted var id: Int = 0
    @Persisted var name: String = ""
}

extension RMSpid: RealmResponseType {
    
    func asResponse() -> SpidDTO {
        return SpidDTO(id: id, name: name)
    }
}
