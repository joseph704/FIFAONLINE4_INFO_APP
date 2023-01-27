//
//  DefaultNetworkSessionManager.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/08/16.
//

import Foundation

import RxSwift
import Alamofire

struct DefaultNetworkSessionManager: NetworkSessionManager {
    func request(_ request: URLRequest) -> Single<(data: Data?, response: URLResponse?, requestError: Error?)> {
        return Single.create { emitter in
            
            let task = AF.request(request).response { response in
                emitter(.success((response.data, response.response, response.error)))
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
