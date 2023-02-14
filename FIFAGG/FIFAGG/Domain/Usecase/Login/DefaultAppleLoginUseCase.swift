//
//  DefaultAppleLoginUseCase.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2023/02/14.
//

import Foundation

import AuthenticationServices
import RxSwift
import RxCocoa

final class DefaultAppleLoginUseCase: AppleLoginUseCase {
    func execute() -> Single<Void>{
        return ASAuthorizationAppleIDProvider().rx.login(scope: [.email, .fullName])
            .asSingle()
            .map { authorization in
                switch authorization.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    let userIdentifier = appleIDCredential.user
                    print("userIdentifier: \(userIdentifier)")
                default:
                    break
                }
            }
    }
}

extension ASAuthorizationController: HasDelegate {
    public typealias Delegate = ASAuthorizationControllerDelegate
}

private final class ASAuthorizationControllerProxy: DelegateProxy<ASAuthorizationController,
                                                    ASAuthorizationControllerDelegate>,
                                                    DelegateProxyType,
                                                    ASAuthorizationControllerDelegate,
                                                    ASAuthorizationControllerPresentationContextProviding {
    var presentationWindow: UIWindow = UIWindow()
    
    public init(controller: ASAuthorizationController) {
        super.init(parentObject: controller, delegateProxy: ASAuthorizationControllerProxy.self)
    }
    
    // MARK: - DelegateProxyType
    public static func registerKnownImplementations() {
        register { ASAuthorizationControllerProxy(controller: $0) }
    }
    
    // MARK: - Proxy Subject
    internal lazy var didComplete = PublishSubject<ASAuthorization>()
    
    // MARK: - ASAuthorizationControllerDelegate
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        didComplete.onNext(authorization)
        didComplete.onCompleted()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        didComplete.onCompleted()
    }
    
    // MARK: - ASAuthorizationControllerPresentationContextProviding
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return presentationWindow
    }
    
    // MARK: - Completed
    deinit {
        self.didComplete.onCompleted()
    }
}

private extension Reactive where Base: ASAuthorizationAppleIDProvider {
    func login(scope: [ASAuthorization.Scope]? = nil) -> Observable<ASAuthorization> {
        let request = base.createRequest()
        request.requestedScopes = scope
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        let proxy = ASAuthorizationControllerProxy.proxy(for: controller)
        
        controller.presentationContextProvider = proxy
        controller.performRequests()
        
        return proxy.didComplete
    }
}
