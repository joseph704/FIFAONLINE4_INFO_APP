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
        
        return dataTransferService.request(with: endpoint).map { (responseDTO, responseEtag) -> Void in
            // TODO: SPID API 통신시, Etag확인하여 realm에 Spid데이터 저장여부 로직 작성해야함
        }
    }
}
