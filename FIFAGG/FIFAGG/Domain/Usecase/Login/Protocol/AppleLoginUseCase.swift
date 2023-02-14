//
//  AppleLoginUseCase.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2023/02/14.
//

import Foundation
import RxSwift

protocol AppleLoginUseCase {
    func execute() -> Single<Void>
}
