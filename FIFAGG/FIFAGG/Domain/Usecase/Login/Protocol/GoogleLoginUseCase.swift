//
//  GoogleLoginUseCase.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2023/02/10.
//

import Foundation
import RxSwift

protocol GoogleLoginUseCase {
    func execute() -> Single<Void>
}
