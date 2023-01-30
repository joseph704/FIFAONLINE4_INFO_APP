//
//  RMSeasonId.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2023/01/30.
//

import Foundation
import RealmSwift

final class RMSeasonId: Object {
    @Persisted(primaryKey: true) var objectID: String = ""
    @Persisted var seasonId: Int
    @Persisted var className: String
    @Persisted var seasonImageURL: String
}

extension RMSeasonId: RealmResponseType {
    
    func asResponse() -> SeasonIdDTO {
        return SeasonIdDTO(
            seasonId: self.seasonId,
            className: self.className,
            seasonImageURL: self.seasonImageURL
        )
    }
}
