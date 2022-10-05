//
//  RealmRepresentable.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/09/27.
//

import Foundation

public protocol RealmRepresentable {
    associatedtype RealmType: RealmResponseType

    var objectID: String { get }
    
    func asRealm() -> RealmType
}
