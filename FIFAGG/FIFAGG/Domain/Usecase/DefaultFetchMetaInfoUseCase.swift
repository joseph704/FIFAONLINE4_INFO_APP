//
//  DefaultFetchMetaInfoUseCase.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/10/12.
//

import Foundation

import RxSwift

final class DefaultFetchMetaInfoUseCase: FetchMetaInfoUseCase {
    private let metaInfoRepository: MetaInfoRepository
    
    init(metaInfoRepository: MetaInfoRepository) {
        self.metaInfoRepository = metaInfoRepository
    }
    
    func execute() -> Observable<Void> {
        return Observable<Void>.merge(
            metaInfoRepository.fetchSpidWithEtag(),
            metaInfoRepository.fetchMatchTypeWithEtag(),
            metaInfoRepository.fetchSeasonIdWithEtag(),
            metaInfoRepository.fetchSPPositionWithEtag(),
            metaInfoRepository.fetchDivisionWithEtag()
        )
    }
}
