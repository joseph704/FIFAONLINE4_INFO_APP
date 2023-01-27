//
//  NetworkSessionManager.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/08/16.
//

import Foundation

import RxSwift

public protocol NetworkSessionManager {
    func request(_ request: URLRequest) -> Single<(data: Data?, response: URLResponse?, requestError: Error?)>
}
