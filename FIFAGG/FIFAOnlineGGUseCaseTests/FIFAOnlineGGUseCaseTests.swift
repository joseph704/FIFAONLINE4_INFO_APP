//
//  FIFAOnlineGGUseCaseTests.swift
//  FIFAOnlineGGUseCaseTests
//
//  Created by Joseph Cha on 2023/02/14.
//

import XCTest

import RxSwift
import GoogleSignIn

final class FIFAOnlineGGUseCaseTests: XCTestCase {
    var sut: GoogleLoginUseCase!
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        self.sut = DefaultGoogleLoginUseCase()
        self.disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        self.sut = nil
    }
    
    func test_googleLogin() {
        let promise = expectation(description: "Google Login timeout 120 seconds")
        
        self.sut.execute()
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
