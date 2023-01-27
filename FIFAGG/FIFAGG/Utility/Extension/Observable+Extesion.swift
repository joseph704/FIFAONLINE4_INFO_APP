//
//  Observable+Extesion.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/09/30.
//

import Foundation
import RxSwift

extension Observable where Element: Sequence, Element.Iterator.Element: RealmResponseType {
    typealias ResponseType = Element.Iterator.Element.ResponseType

    func mapToResponseType() -> Observable<[ResponseType]> {
        return map { sequence -> [ResponseType] in
            return sequence.mapToResponseType()
        }
    }
}

extension Sequence where Iterator.Element: RealmResponseType {
    typealias Element = Iterator.Element
    func mapToResponseType() -> [Element.ResponseType] {
        return map {
            return $0.asResponse()
        }
    }
}
