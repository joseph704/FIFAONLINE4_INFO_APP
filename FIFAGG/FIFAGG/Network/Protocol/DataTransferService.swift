//
//  DataTransferService.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/08/16.
//

import Foundation

import RxSwift

public protocol DataTransferService {
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E) -> Single<T> where E.Response == T
    func request<E: ResponseRequestable>(with endpoint: E) -> Single<Void> where E.Response == Void
}
