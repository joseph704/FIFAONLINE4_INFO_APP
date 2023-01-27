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
    private let disposeBag = DisposeBag()
    
    init(dataTransferService: DataTransferService,
         spidRealmStorage: DefaultRealmStorage<SpidDTO>
    ) {
        self.dataTransferService = dataTransferService
        self.spidRealmStorage = spidRealmStorage
    }
}

extension DefaultMetaInfoRepository: MetaInfoRepository {
    func fetchSpidWithEtag() -> Single<Void> {
        let savedEtag: String = UserDefaults.standard.string(forKey: UserDefaultsKey.spidEtag) ?? ""
        let endpoint = APIEndpoints.getSpidEtag(etag: savedEtag)
        
        return Single<Void>.create { [weak self] singleCloser in
            
            guard let self = self else { return Disposables.create() }
            
            self.dataTransferService.requestWithEtag(with: endpoint)
                .subscribe(onSuccess: { (response, isServerDataUpdated, etag) in
                    
                    UserDefaults.standard.set(etag, forKey: UserDefaultsKey.spidEtag) // 서버로 부터 받은 etag 저장
                    
                    if isServerDataUpdated { // HTTP StatusCode가 200대면 isServerDataUpdated값은 true, 즉 Realm의 선수정보 업데이트
                        response?.forEach { [weak self] spidDTO in
                            guard let self = self else { return }
                            
                            self.spidRealmStorage.save(entity: spidDTO)
                                .subscribe(onNext: {
                                    singleCloser(.success(()))
                                }, onError: { error in
                                    singleCloser(.failure(error))
                                })
                                .disposed(by: self.disposeBag)
                        }
                    } else { // HTTP StatusCode가 200대가 아니면 isServerDataUpdated값은 false, 즉 Realm의 선수정보 업데이트 하지 않음
                        singleCloser(.success(()))
                    }
                }, onFailure: { networkError in
                    singleCloser(.failure(networkError))
                })
                .disposed(by: self.disposeBag)

            return Disposables.create()
        }
    }
}
