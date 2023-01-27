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
    func requestWithEtag<T: Decodable, E: ResponseRequestable>(with endpoint: E) -> Single<(response: T?, isServerDataUpdated: Bool, etag: String)> where E.Response == T // etag와 함께 response값 전달
}
