//
//  DefaultMetaInfoRepository.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/08/18.
//

import Foundation

import RxSwift
import RealmSwift

final class DefaultMetaInfoRepository {
    private let dataTransferService: DataTransferService
    private let spidRealmStorage: DefaultRealmStorage<SpidDTO>
    private let matchtypeRealmStorage: DefaultRealmStorage<MatchtypeDTO>
    private let seasonIdRealmStorage: DefaultRealmStorage<SeasonIdDTO>
    private let disposeBag = DisposeBag()
    
    init(dataTransferService: DataTransferService,
         spidRealmStorage: DefaultRealmStorage<SpidDTO>,
         matchtypeRealmStorage: DefaultRealmStorage<MatchtypeDTO>,
         seasonIdRealmStorage: DefaultRealmStorage<SeasonIdDTO>
    ) {
        self.dataTransferService = dataTransferService
        self.spidRealmStorage = spidRealmStorage
        self.matchtypeRealmStorage = matchtypeRealmStorage
        self.seasonIdRealmStorage = seasonIdRealmStorage
    }
}

extension DefaultMetaInfoRepository: MetaInfoRepository {
    func fetchSpidWithEtag() -> Observable<Void> {
        let savedEtag: String = UserDefaults.standard.string(forKey: UserDefaultsKey.spidEtag) ?? ""
        let endpoint = APIEndpoints.getSpidEtag(etag: savedEtag)
        
        return self.fetchMetaInfo(
            metaInfoRealmStorage: self.spidRealmStorage,
            endpoint: endpoint,
            userDefaultsKey: UserDefaultsKey.spidEtag
        )
    }
    
    func fetchMatchTypeWithEtag() -> Observable<Void> {
        let savedEtag: String = UserDefaults.standard.string(forKey: UserDefaultsKey.matchTypeEtag) ?? ""
        let endpoint = APIEndpoints.getMatchTypeEtag(etag: savedEtag)
        
        return self.fetchMetaInfo(
            metaInfoRealmStorage: self.matchtypeRealmStorage,
            endpoint: endpoint,
            userDefaultsKey: UserDefaultsKey.matchTypeEtag
        )
    }
    
    func fetchSeasonIdWithEtag() -> Observable<Void> {
        let savedEtag: String = UserDefaults.standard.string(forKey: UserDefaultsKey.seasonIdEtag) ?? ""
        let endpoint = APIEndpoints.getSeasonIdEtag(etag: savedEtag)
        
        return self.fetchMetaInfo(
            metaInfoRealmStorage: self.seasonIdRealmStorage,
            endpoint: endpoint,
            userDefaultsKey: UserDefaultsKey.seasonIdEtag
        )
    }
}

//MARK: Private Extension
private extension DefaultMetaInfoRepository {
    func fetchMetaInfo<T: RealmRepresentable>(
        metaInfoRealmStorage: DefaultRealmStorage<T>,
        endpoint: Endpoint<[T]>,
        userDefaultsKey: String
    ) -> Observable<Void> where T: Decodable {
        return Observable<Void>.create { [weak self] observer -> Disposable in
            
            guard let self = self else { return Disposables.create() }
            
            self.dataTransferService.requestWithEtag(with: endpoint)
                .subscribe(onSuccess: { (response, isServerDataUpdated, etag) in
                    
                    UserDefaults.standard.set(etag, forKey: userDefaultsKey) // 서버로 부터 받은 etag 저장
                    
                    if isServerDataUpdated { // HTTP StatusCode가 200대면 isServerDataUpdated값은 true, 즉 Realm의 선수정보 업데이트
                        guard let response = response else {
                            observer.onCompleted()
                            return
                        }
                        
                        metaInfoRealmStorage.save(entities: response)
                            .subscribe(onError: { error in
                                observer.onError(error)
                            },onCompleted: {
                                observer.onCompleted()
                            })
                            .disposed(by: self.disposeBag)
                    } else { // HTTP StatusCode가 200대가 아니면 isServerDataUpdated값은 false, 즉 Realm의 선수정보 업데이트 하지 않음
                        observer.onCompleted()
                    }
                }, onFailure: { networkError in
                    observer.onError(networkError)
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
