//
//  DefaultGoogleLoginUseCase.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2023/02/10.
//

import Foundation
import GoogleSignIn
import RxSwift

final class DefaultGoogleLoginUseCase: GoogleLoginUseCase {
    func execute() -> Single<Void>{
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            return .error(GoogleLoginError.presentingViewControllerError)
        }
        
        return Single<Void>.create { emitter in
            GIDSignIn.sharedInstance.signIn(
                withPresenting: presentingViewController,
                completion: { signInResult, error in
                    if let error = error {
                        emitter(.failure(error))
                        return
                    } else {
                        emitter(.success(()))
                    }
                }
            )
            
            return Disposables.create()
        }
    }
}
