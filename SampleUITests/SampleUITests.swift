//
//  SampleUITests.swift
//  SampleUITests
//
//  Created by Alexey Alter Pesotskiy  on 5/7/23.
//

import XCTest

class SampleUITests: XCTestCase {
    
    let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
    
    override func setUp() {
        super.setUp()
        safari.launch()
        _ = safari.wait(for: .runningForeground, timeout: 10)
    }
    
    override func tearDown() {
        super.tearDown()
        CommandLine.setConnection(state: .on)
    }
    
    func testOfflineScenario() {
        CommandLine.setConnection(state: .off)
        
        open(url: "https://testableapple.com/")
        let msg = safari.staticTexts.matching(NSPredicate(format: "label CONTAINS 'your iPhone is not connected to the Internet'"))
        let networkDisabled = msg.firstMatch.waitForExistence(timeout: 10)
        
        XCTAssertTrue(networkDisabled, "Network should be disabled")
    }
    
    func open(url: String) {
        safari.textFields["TabBarItemTitle"].tap()
        safari.textFields["URL"].typeText(url + XCUIKeyboardKey.return.rawValue)
    }
}
