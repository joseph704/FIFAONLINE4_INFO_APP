//
//  DefaultNetworkService.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/08/16.
//

import Foundation

import RxSwift

public enum NetworkResult {
    case success(data: Data?, isServerDataUpdated: Bool, etag: String)
    case failure(NetworkError)
}

public enum NetworkError: Int, Error, CustomStringConvertible {
    public var description: String { self.errorDescription }
    
    case emptyDataError
    case responseDecodingError
    case payloadEncodingError
    case unknownError
    case invalidURLError
    case notConnectedToInternet
    case cancelled
    case urlGeneration
    case notModified = 304
    case invalidRequestError = 400
    case authenticationError = 401
    case forbiddenError = 403
    case notFoundError = 404
    case notAllowedHTTPMethodError = 405
    case timeoutError = 408
    case internalServerError = 500
    case notSupportedError = 501
    case badGatewayError = 502
    case invalidServiceError = 503
    
    var errorDescription: String {
        switch self {
        case .invalidURLError: return "INVALID_URL_ERROR"
        case .invalidRequestError: return "400:INVALID_REQUEST_ERROR"
        case .authenticationError: return "401:AUTHENTICATION_FAILURE_ERROR"
        case .forbiddenError: return "403:FORBIDDEN_ERROR"
        case .notFoundError: return "404:NOT_FOUND_ERROR"
        case .notAllowedHTTPMethodError: return "405:NOT_ALLOWED_HTTP_METHOD_ERROR"
        case .timeoutError: return "408:TIMEOUT_ERROR"
        case .internalServerError: return "500:INTERNAL_SERVER_ERROR"
        case .notSupportedError: return "501:NOT_SUPPORTED_ERROR"
        case .badGatewayError: return "502:BAD_GATEWAY_ERROR"
        case .invalidServiceError: return "503:INVALID_SERVICE_ERROR"
        case .responseDecodingError: return "RESPONSE_DECODING_ERROR"
        case .payloadEncodingError: return "REQUEST_BODY_ENCODING_ERROR"
        case .unknownError: return "UNKNOWN_ERROR"
        case .emptyDataError: return "RESPONSE_DATA_EMPTY_ERROR"
        case .notConnectedToInternet: return "NOT_CONNECTED_TO_INTERNET"
        case .cancelled: return "CANCELLED"
        case .urlGeneration: return "URLGeneration"
        case .notModified: return "304:NOT_MODIFIED"
        }
    }
}

public protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

struct DefaultNetworkService {
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    private let logger: NetworkErrorLogger
    private let disposeBag = DisposeBag()
    
    public init(config: NetworkConfigurable,
                sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(),
                logger: NetworkErrorLogger = DefaultNetworkErrorLogger()) {
        self.sessionManager = sessionManager
        self.config = config
        self.logger = logger
    }
    
    private func request(request: URLRequest) -> Single<NetworkResult> {
        logger.log(request: request)
        
        return sessionManager.request(request)
            .map { sessionDataDaskresult -> NetworkResult in
                var error: NetworkError
                if let requestError = sessionDataDaskresult.requestError {
                    if let response = sessionDataDaskresult.response {
                        error = NetworkError(rawValue: response.statusCode) ?? .unknownError
                    } else {
                        error = self.resolve(error: requestError)
                    }
                    self.logger.log(error: error)
                    return .failure(error)
                } else {
                    if let response = sessionDataDaskresult.response {
                        let etag = response.allHeaderFields["Etag"] as? String
                        switch response.statusCode {
                        case (200...299):
                            self.logger.log(
                                responseData: sessionDataDaskresult.data,
                                response: sessionDataDaskresult.response
                            )
                            return .success(
                                data: sessionDataDaskresult.data,
                                isServerDataUpdated: true,
                                etag: etag ?? "")
                        case 304:
                            self.logger.log(responseData: sessionDataDaskresult.data, response: sessionDataDaskresult.response)
                            return .success(
                                data: nil,
                                isServerDataUpdated: false,
                                etag: etag ?? "")
                        default:
                            error = NetworkError(rawValue: response.statusCode) ?? .unknownError
                            self.logger.log(error: error)
                            return .failure(error)
                        }
                    } else {
                        self.logger.log(error: NetworkError.unknownError)
                        return .failure(NetworkError.unknownError)
                    }
                }
            }
    }
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnectedToInternet
        case .cancelled: return .cancelled
        default: return .unknownError
        }
    }
}

extension DefaultNetworkService: NetworkService {
    func request(endPoint: Requestable) -> Single<NetworkResult> {
        do {
            let urlRequest = try endPoint.urlRequest(with: config)
            return request(request: urlRequest)
        } catch {
            return Single.just(.failure(.urlGeneration))
        }
    }
}

// MARK: - Logger

public final class DefaultNetworkErrorLogger: NetworkErrorLogger {
    public init() { }
    
    public func log(request: URLRequest) {
        print("-------------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            printIfDebug("body: \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            printIfDebug("body: \(String(describing: resultString))")
        }
    }
    
    public func log(responseData data: Data?, response: URLResponse?) {
        guard let data = data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            printIfDebug("responseData: \(String(describing: dataDict))")
        }
    }
    
    public func log(error: Error) {
        printIfDebug("\(error)")
    }
}

func printIfDebug(_ string: String) {
#if DEBUG
    print(string)
#endif
}
