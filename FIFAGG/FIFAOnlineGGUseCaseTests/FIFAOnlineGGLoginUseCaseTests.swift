//
//  FIFAOnlineGGLoginUseCaseTests.swift
//  FIFAOnlineGGLoginUseCaseTests
//
//  Created by Joseph Cha on 2023/02/14.
//

import XCTest

import RxSwift
import GoogleSignIn

final class FIFAOnlineGGLoginUseCaseTests: XCTestCase {
    var googleLoginUseCase: GoogleLoginUseCase!
    var appleLoginUseCase: AppleLoginUseCase!
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        self.googleLoginUseCase = DefaultGoogleLoginUseCase()
        self.appleLoginUseCase = DefaultAppleLoginUseCase()
        self.disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        self.googleLoginUseCase = nil
        self.appleLoginUseCase = nil
        self.disposeBag = nil
    }
    
    func test_googleLogin() {
        let promise = expectation(description: "Google Login timeout 120 seconds")
        
        self.googleLoginUseCase.execute()
            .subscribe(onSuccess: {
                XCTAssert(true)
                promise.fulfill()
            }, onFailure: { error in
                XCTAssert(false, error.localizedDescription)
                promise.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [promise], timeout: 120)
    }
    
    func test_appleLogin() {
        let promise = expectation(description: "Apple Login timeout 120 seconds")
        
        self.appleLoginUseCase.execute()
            .subscribe(onSuccess: {
                XCTAssert(true)
                promise.fulfill()
            }, onFailure: { error in
                XCTAssert(false, error.localizedDescription)
                promise.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [promise], timeout: 120)
    }
}
