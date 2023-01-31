//
//  RMSPPostion.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2023/02/01.
//

import Foundation
import RealmSwift

final class RMSPPostion: Object {
    @Persisted(primaryKey: true) var objectID: String = ""
    @Persisted var spPosition: Int
    @Persisted var desc: String
}

extension RMSPPostion: RealmResponseType {
    
    func asResponse() -> SPPostionDTO {
        return SPPostionDTO(
            spPosition: self.spPosition,
            desc: self.desc
        )
    }
}
