//
//  NetworkConfigurable.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/08/17.
//

import Foundation

public protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}
