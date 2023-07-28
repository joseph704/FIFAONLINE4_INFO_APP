//
//  FIFAGGSwiftUIUITestsLaunchTests.swift
//  FIFAGGSwiftUIUITests
//
//  Created by 민성홍 on 2023/07/27.
//

import XCTest

final class FIFAGGSwiftUIUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
