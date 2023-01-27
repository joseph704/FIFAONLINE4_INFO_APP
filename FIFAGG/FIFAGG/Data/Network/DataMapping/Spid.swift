//
//  Spid.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/09/08.
//

import Foundation

protocol EtagModel: Decodable {
    var etag: String { get set }
}

struct Spid: EtagModel {
    var etag: String
}
