//
//  DefaultRealmStorage.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/09/27.
//

import Foundation

import RealmSwift
import RxSwift
import RxRealm

final class DefaultRealmStorage<T: RealmRepresentable>: RealmStorage where T == T.RealmType.ResponseType, T.RealmType: Object {
    private let configuration: Realm.Configuration
    
    init(configuration: Realm.Configuration) {
        self.configuration = configuration
    }
    
    private var realm: Realm {
        return try! Realm(configuration: self.configuration)
    }
    
    func queryAll() -> Observable<[T]> {
        return Observable.deferred {
            let realm = self.realm
            let objects = realm.objects(T.RealmType.self)
            
            return Observable.array(from: objects)
                .mapToResponseType()
        }
        
    }
    
    func query(with predicate: NSPredicate,
               sortDescriptors: [NSSortDescriptor] = []) -> Observable<[T]> {
        return Observable.deferred {
            let realm = self.realm
            let objects = realm.objects(T.RealmType.self)
//            The implementation is broken since we are not using predicate and sortDescriptors
//            but it cause compiler to crash with xcode 8.3 ¯\_(ツ)_/¯
//                            .filter(predicate)
//                            .sorted(by: sortDescriptors.map(SortDescriptor.init))
            return Observable.array(from: objects)
                .mapToResponseType()
        }
    }

    func save(entity: T) -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.save(entity: entity)
        }
    }

    func save(entities: [T]) -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.save(entities: entities)
        }
    }
    
    func delete(entity: T) -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.delete(entity: entity)
        }
    }
}
