//
//  DefaultFetchSpidUseCase.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/10/12.
//

import Foundation

import RxSwift

final class DefaultFetchSpidUseCase: FetchSpidUseCase {
    private let metaInfoRepository: MetaInfoRepository
    
    init(metaInfoRepository: MetaInfoRepository) {
        self.metaInfoRepository = metaInfoRepository
    }
    
    func execute() -> Single<Void> {
        return metaInfoRepository.fetchSpidWithEtag()
    }
}
