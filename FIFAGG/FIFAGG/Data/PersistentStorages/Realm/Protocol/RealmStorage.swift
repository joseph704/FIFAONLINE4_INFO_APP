//
//  RealmStorage.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/09/27.
//

import Foundation

import RxSwift

public protocol RealmStorage {
    associatedtype T
    func queryAll() -> Observable<[T]>
    func query(with predicate: NSPredicate,
               sortDescriptors: [NSSortDescriptor]) -> Observable<[T]>
    func save(entity: T) -> Observable<Void>
    func delete(entity: T) -> Observable<Void>
}
