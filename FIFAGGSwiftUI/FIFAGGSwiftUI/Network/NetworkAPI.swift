//
//  NetworkAPI.swift
//  FIFAGGSwiftUI
//
//  Created by 민성홍 on 2023/07/28.
//

import Foundation
import Moya

enum NetworkAPI {
    case fetchUserAccessID(nickName: String)
    case fetchHighestRating(accessID: String)
    case fetchUserMatchHistory(
        accessID: String,
        matchType: Int,
        offset: Int = 0,
        limit: Int = 100
    )
    case fetchUserTransactionHistory(
        accessID: String,
        tradetType: Int,
        offset: Int = 0,
        limit: Int = 100
    )
    case fetchTypeOfMatch
    case fetchSPID
    case fetchSeasonID
    case fetchSPPosition
    case fetchDetailOfMatch(matchID: String)
    case fetchDevision
    case fetchActionShotImageOfPlayer(spID: Int)
}

extension NetworkAPI: TargetType {
    var baseURL: URL {
        switch self {
            case .fetchActionShotImageOfPlayer:
                return URL(string: "https://fo4.dn.nexoncdn.co.kr/live/externalAssets/common/playersAction")!
            default:
                return URL(string: "https://api.nexon.co.kr/fifaonline4")!
        }
    }

    var path: String {
        switch self {
            case .fetchUserAccessID:
                return "v1.0/users"
            case .fetchHighestRating(accessID: let accessID):
                return "v1.0/users/\(accessID)/maxdivision"
            case .fetchUserMatchHistory(accessID: let accessID):
                return "v1.0/users/\(accessID)/matches"
            case .fetchUserTransactionHistory(accessID: let accessID):
                return "v1.0/users/\(accessID)/market"
            case .fetchTypeOfMatch:
                return "latest/matchtype.json"
            case .fetchSPID:
                return "latest/spid.json"
            case .fetchSeasonID:
                return "latest/seasonid.json"
            case .fetchSPPosition:
                return "latest/spposition.json"
            case .fetchDetailOfMatch(matchID: let matchID):
                return "v1.0/matches/\(matchID)"
            case .fetchDevision:
                return "latest/division.json"
            case .fetchActionShotImageOfPlayer(spID: let spID):
                return "p\(spID).png"
        }
    }

    var method: Moya.Method { .get }

    var task: Moya.Task {
        switch self {
            case .fetchUserAccessID(nickName: let nickName):
                return .requestParameters(
                    parameters: [
                        "nickname" : nickName
                    ],
                    encoding: URLEncoding.queryString
                )
            case .fetchUserMatchHistory(
                accessID: let accessID,
                matchType: let matchType,
                offset: let offset,
                limit: let limit
            ):
                return .requestParameters(
                    parameters: [
                        "accessid" : accessID,
                        "matchtype" : matchType,
                        "offset" : offset,
                        "limit" : limit
                    ],
                    encoding: URLEncoding.queryString
                )
            case .fetchUserTransactionHistory(
                accessID: let accessID,
                tradetType: let tradetType,
                offset: let offset,
                limit: let limit
            ):
                return .requestParameters(
                    parameters: [
                        "accessid" : accessID,
                        "tradetype" : tradetType,
                        "offset" : offset,
                        "limit" : limit
                    ],
                    encoding: URLEncoding.queryString
                )
            default:
                return .requestPlain
        }
    }

    var apiKey: String {
        guard let url = Bundle.main.url(forResource: "APIKey", withExtension: "plist") else {
            return ""
        }

        guard let apiDictionary = NSDictionary(contentsOf: url) else {
            return ""
        }

        return apiDictionary["accessID"] as? String ?? ""
    }

    var headers: [String : String]? {
        return [
            "Authorization" : apiKey
        ]
    }
}
