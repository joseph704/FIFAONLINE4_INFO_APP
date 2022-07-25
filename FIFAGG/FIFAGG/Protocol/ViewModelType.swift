//
//  ViewModelType.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/07/14.
//

import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func convert(from: Input, disposedBag: DisposeBag) -> Output
}
