//
//  FetchMetaInfoUseCase.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/10/12.
//

import Foundation

import RxSwift

protocol FetchMetaInfoUseCase {
    func execute() -> Observable<Void>
}
