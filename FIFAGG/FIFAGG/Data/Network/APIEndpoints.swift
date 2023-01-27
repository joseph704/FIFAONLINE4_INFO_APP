//
//  APIEndpoints.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/08/31.
//

import Foundation

struct APIEndpoints {
    static func getSpidEtag(etag: String) -> Endpoint<[Spid]> {
        return Endpoint(path: "spid.json",
                        method: .get,
                        headerParameters: ["If-None-Match": etag])
    }
}
