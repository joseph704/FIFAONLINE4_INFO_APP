//
//  MetaInfoRepository.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/08/18.
//

import Foundation

import RxSwift

protocol MetaInfoRepository {
    func fetchSpidWithEtag() -> Single<Void>
}
