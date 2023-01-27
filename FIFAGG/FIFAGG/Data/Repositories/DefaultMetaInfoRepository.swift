//
//  DefaultMetaInfoRepository.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/08/18.
//

import Foundation

import RxSwift

final class DefaultMetaInfoRepository {
    private let dataTransferService: DataTransferService
// TODO: realm datasource 객체 생성해야함
    private let disposeBag = DisposeBag()
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultMetaInfoRepository: MetaInfoRepository {
    func fetchSpidWithEtag(etag: String) -> Single<Void> {
        let endpoint = APIEndpoints.getSpidEtag(etag: etag)
        return dataTransferService.request(with: endpoint).map { (responseDTO, responseEtag) -> Void in
// TODO: SPID API 통신시, Etag확인하여 realm에 Spid데이터 저장여부 로직 작성해야함
        }
    }
}
