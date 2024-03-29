//
//  Realm+Extension.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/09/27.
//

import Foundation

import RealmSwift
import RxSwift

extension Object {
    static func build<O: Object>(_ builder: (O) -> () ) -> O {
        let object = O()
        builder(object)
        return object
    }
}

extension RealmSwift.SortDescriptor {
    init(sortDescriptor: NSSortDescriptor) {
        self.init(keyPath: sortDescriptor.key ?? "", ascending: sortDescriptor.ascending)
    }
}

extension Reactive where Base == Realm {

    /**
        Realm 객체를 저장하는 메소드

        - Parameters:
           - entity: RealmRepresentable (Realm 객체).
           - update: 업데이트 유무 Bool값.
     */
    func save<R: RealmRepresentable>(entity: R, update: Bool = true) -> Observable<Void> where R.RealmType: Object {
        return Observable.create { observer in
            do {
                try self.base.write {
                    self.base.add(entity.asRealm(), update: update ? .all : .error)
                }
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    /**
        Realm 객체 배열을 저장하는 메소드

        - Parameters:
            - entity: RealmRepresentable (Realm 객체).
            - update: 업데이트 유무 Bool값.
     */
    func save<R: RealmRepresentable>(entities: [R], update: Bool = true) -> Observable<Void> where R.RealmType: Object {
        return Observable.create { observer in
            do {
                try self.base.write {
                    for entity in entities {
                        self.base.add(entity.asRealm(), update: update ? .all : .error)
                    }
                }
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func delete<R: RealmRepresentable>(entity: R) -> Observable<Void> where R.RealmType: Object {
        return Observable.create { observer in
            do {
                guard let object = self.base.object(ofType: R.RealmType.self, forPrimaryKey: entity.objectID) else { fatalError() }

                try self.base.write {
                    self.base.delete(object)
                }

                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
