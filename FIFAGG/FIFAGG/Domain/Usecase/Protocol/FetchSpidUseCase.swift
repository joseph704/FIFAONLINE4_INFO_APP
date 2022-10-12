//
//  FetchSpidUseCase.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/10/12.
//

import Foundation

import RxSwift

protocol FetchSpidUseCase {
    func execute() -> Single<Void>
}
