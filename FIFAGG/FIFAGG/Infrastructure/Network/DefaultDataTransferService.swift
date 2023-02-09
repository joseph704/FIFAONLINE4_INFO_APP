//
//  DefaultDataTransferService.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/08/16.
//

import Foundation

import RxSwift

public enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

public protocol DataTransferErrorResolver {
    func resolve(error: NetworkError) -> Error
}

public protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

public protocol DataTransferErrorLogger {
    func log(error: Error)
}

struct DefaultDataTransferService {
    private let networkService: NetworkService
    private let errorResolver: DataTransferErrorResolver
    private let errorLogger: DataTransferErrorLogger
    
    public init(with networkService: NetworkService,
                errorResolver: DataTransferErrorResolver = DefaultDataTransferErrorResolver(),
                errorLogger: DataTransferErrorLogger = DefaultDataTransferErrorLogger()) {
        self.networkService = networkService
        self.errorResolver = errorResolver
        self.errorLogger = errorLogger
    }
}

extension DefaultDataTransferService: DataTransferService {
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E) -> Single<T> where E.Response == T {
        return self.networkService.request(endPoint: endpoint)
            .flatMap { networkResult in
                switch networkResult {
                case .success(let data, _, _):
                    let result: Single<T> = self.decode(data: data, decoder: endpoint.responseDecoder)
                    return result
                case .failure(let networkError):
                    self.errorLogger.log(error: networkError)
                    let error = self.resolve(networkError: networkError)
                    return Single<T>.error(error)
                }
            }
    }
    
    func request<E: ResponseRequestable>(with endpoint: E) -> Single<Void> where E.Response == Void {
        let result: Single<Void> = self.networkService.request(endPoint: endpoint)
            .flatMap { networkResult in
                switch networkResult {
                case .success(_, _, _):
                    return Single.just(())
                case .failure(let networkError):
                    self.errorLogger.log(error: networkError)
                    let error = self.resolve(networkError: networkError)
                    return Single.error(error)
                }
            }
        return result
    }
    
    func requestWithEtag<T: Decodable, E: ResponseRequestable>(with endpoint: E) -> Single<(response: T?, isServerDataUpdated: Bool, etag: String)> where E.Response == T {
        return self.networkService.request(endPoint: endpoint)
            .flatMap { networkResult in
                switch networkResult {
                case .success(let data, let isServerDataUpdated, let etag):
                    if isServerDataUpdated {
                        let result: Single<T> = self.decode(data: data, decoder: endpoint.responseDecoder)
                        return result.map { ($0, isServerDataUpdated, etag) }
                    } else {
                        return Single<(response: T?, isServerDataUpdated: Bool, etag: String)>.just((nil, false, etag))
                    }
                    
                case .failure(let networkError):
                    self.errorLogger.log(error: networkError)
                    let error = self.resolve(networkError: networkError)
                    return Single<T>.create { singleCloser in
                        singleCloser(.failure(error))
                        return Disposables.create()
                    }.map {($0, false, "")}
                }
            }
    }
    
    // MARK: - Private
    private func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) -> Single<T> {
        return Single.create { emitter in
            do {
                guard let data = data else {
                    emitter(.failure(DataTransferError.noResponse))
                    return Disposables.create()
                }
                let result: T = try decoder.decode(data)
                emitter(.success(result))
            } catch {
                self.errorLogger.log(error: error)
                emitter(.failure(DataTransferError.parsing(error)))
            }
            
            return Disposables.create()
        }
    }
    
    private func resolve(networkError error: NetworkError) -> DataTransferError {
        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is NetworkError ? .networkFailure(error) : .resolvedNetworkFailure(resolvedError)
    }
}

// MARK: - Logger
public final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
    public init() { }
    
    public func log(error: Error) {
        printIfDebug("-------------")
        printIfDebug("\(error)")
    }
}

// MARK: - Error Resolver
public class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
    public init() { }
    public func resolve(error: NetworkError) -> Error {
        return error
    }
}

// MARK: - Response Decoders
public class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    public init() { }
    public func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}

public class RawDataResponseDecoder: ResponseDecoder {
    public init() { }
    
    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    public func decode<T: Decodable>(_ data: Data) throws -> T {
        if T.self is Data.Type, let data = data as? T {
            return data
        } else {
            let context = DecodingError.Context(codingPath: [CodingKeys.default], debugDescription: "Expected Data type")
            throw Swift.DecodingError.typeMismatch(T.self, context)
        }
    }
}
