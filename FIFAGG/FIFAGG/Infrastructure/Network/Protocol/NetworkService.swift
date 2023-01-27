//
//  NetworkService.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/08/16.
//

import Foundation

import RxSwift

public protocol NetworkService {
    func request(endPoint: Requestable) -> Single<NetworkResult>
}
