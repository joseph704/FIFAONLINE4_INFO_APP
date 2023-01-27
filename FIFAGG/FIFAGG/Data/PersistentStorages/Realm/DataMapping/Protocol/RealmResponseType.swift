//
//  RealmResponseType.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/09/30.
//

import Foundation

public protocol RealmResponseType {
    associatedtype ResponseType

    func asResponse() -> ResponseType
}
