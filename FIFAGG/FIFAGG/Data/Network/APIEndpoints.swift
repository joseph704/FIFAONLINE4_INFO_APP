//
//  APIEndpoints.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/08/31.
//

import Foundation

struct APIEndpoints {
    static func getSpidEtag(etag: String) -> Endpoint<[SpidDTO]> {
        return Endpoint(path: "spid.json",
                        method: .get,
                        headerParameters: ["If-None-Match": etag])
    }
    
    static func getMatchTypeEtag(etag: String) -> Endpoint<[MatchtypeDTO]> {
        return Endpoint(path: "matchtype.json",
                        method: .get,
                        headerParameters: ["If-None-Match": etag])
    }
    
    static func getSeasonIdEtag(etag: String) -> Endpoint<[SeasonIdDTO]> {
        return Endpoint(path: "seasonid.json",
                        method: .get,
                        headerParameters: ["If-None-Match": etag])
    }
    
    static func getSPPositionEtag(etag: String) -> Endpoint<[SPPostionDTO]> {
        return Endpoint(path: "spposition.json",
                        method: .get,
                        headerParameters: ["If-None-Match": etag])
    }
}
