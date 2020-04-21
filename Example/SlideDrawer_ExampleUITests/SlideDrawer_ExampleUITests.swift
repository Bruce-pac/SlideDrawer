//
//  SlideDrawer_ExampleUITests.swift
//  SlideDrawer_ExampleUITests
//
//  Created by gxy on 2020/4/21.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import SlideDrawer_Example
import SlideDrawer

class SlideDrawer_ExampleUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPushFromLeftAndDismiss() throws {
        // UI tests must launch the application that they test.
        // Use recording to get started writing UI tests.
        let pushfromLeft = app.tables/*@START_MENU_TOKEN@*/.cells.staticTexts["push from left"]/*[[".cells.staticTexts[\"push from left\"]",".staticTexts[\"push from left\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        pushfromLeft.tap()

        let leftVC: XCUIElement = app.tables.containing(.other, identifier:"LeftViewController").element
        let fromVC = app.otherElements.matching(identifier: "TabBarController").element

        let screenFrame = app.frame
        let config = SlideDrawerConfiguration(animationType: .push, direction: .left, distance: screenFrame.width * 0.75)
        let expectFrame = CGRect(x: 0, y: 0, width: config.distance, height: screenFrame.height)
        let expectFromFrame = CGRect(x: config.distance, y: 0, width: screenFrame.width, height: screenFrame.height)

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(leftVC.exists)
        XCTAssertEqual(leftVC.frame, expectFrame)
        XCTAssertEqual(fromVC.frame, expectFromFrame)

        app.tables/*@START_MENU_TOKEN@*/.cells.staticTexts["dismiss"]/*[[".cells.staticTexts[\"dismiss\"]",".staticTexts[\"dismiss\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()

        let expectMainFrame = CGRect(x: 0, y: 0, width: screenFrame.width, height: screenFrame.height)

        XCTAssertFalse(leftVC.exists)
        XCTAssertEqual(fromVC.frame, expectMainFrame)
    }

    func testPushFromRightAndDismiss() throws {
        // UI tests must launch the application that they test.
        // Use recording to get started writing UI tests.
        let pushfromLeft = app.tables.cells.staticTexts["push from right"]
        pushfromLeft.tap()

        let presentedVC: XCUIElement = app.tables.containing(.other, identifier:"RightViewController").element
        let fromVC = app.otherElements.matching(identifier: "TabBarController").element

        let screenFrame = app.frame
        let config = SlideDrawerConfiguration(animationType: .push, direction: .right, distance: screenFrame.width * 0.75)
        let expectFrame = CGRect(x: screenFrame.width - config.distance, y: 0, width: config.distance, height: screenFrame.height)
        let expectFromFrame = CGRect(x: -config.distance, y: 0, width: screenFrame.width, height: screenFrame.height)

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(presentedVC.exists)
        XCTAssertEqual(presentedVC.frame, expectFrame)
        XCTAssertEqual(fromVC.frame, expectFromFrame)

        app.tables/*@START_MENU_TOKEN@*/.cells.staticTexts["dismiss"]/*[[".cells.staticTexts[\"dismiss\"]",".staticTexts[\"dismiss\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()

        let expectMainFrame = CGRect(x: 0, y: 0, width: screenFrame.width, height: screenFrame.height)

        XCTAssertFalse(presentedVC.exists)
        XCTAssertEqual(fromVC.frame, expectMainFrame)
    }

    func testZoomFromLeftAndDismiss() throws {
        // UI tests must launch the application that they test.
        // Use recording to get started writing UI tests.
        let pushfromLeft = app.tables.cells.staticTexts["zoom from left"]
        pushfromLeft.tap()

        let presentedVC: XCUIElement = app.tables.containing(.other, identifier:"LeftViewController").element
        let fromVC = app.otherElements.matching(identifier: "TabBarController").element

        let screenFrame = app.frame
        let config = SlideDrawerConfiguration(animationType: .zoom, direction: .left, distance: screenFrame.width * 0.75, scaleY: 0.8)
        let expectFrame = CGRect(x: 0, y: 0, width: config.distance, height: screenFrame.height)
        let height: CGFloat = screenFrame.height * config.scaleY
        let y: CGFloat = (screenFrame.height - height) / 2
        let expectFromFrame = CGRect(x: config.distance, y: y, width: screenFrame.width, height: height)

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(presentedVC.exists)
        XCTAssertEqual(presentedVC.frame, expectFrame)
        XCTAssertEqual(fromVC.frame.origin, expectFromFrame.origin)
//        XCTAssertEqual(fromVC.frame.size, expectFromFrame.size)

        app.tables/*@START_MENU_TOKEN@*/.cells.staticTexts["dismiss"]/*[[".cells.staticTexts[\"dismiss\"]",".staticTexts[\"dismiss\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()

        let expectMainFrame = CGRect(x: 0, y: 0, width: screenFrame.width, height: screenFrame.height)

        XCTAssertFalse(presentedVC.exists)
        XCTAssertEqual(fromVC.frame, expectMainFrame)
    }

    func testZoomFromRightAndDismiss() throws {
        // UI tests must launch the application that they test.
        // Use recording to get started writing UI tests.
        let pushfromLeft = app.tables.cells.staticTexts["zoom from right"]
        pushfromLeft.tap()

        let presentedVC: XCUIElement = app.tables.containing(.other, identifier:"RightViewController").element
        let fromVC = app.otherElements.matching(identifier: "TabBarController").element

        let screenFrame = app.frame
        let config = SlideDrawerConfiguration(animationType: .zoom, direction: .right, distance: screenFrame.width * 0.75, scaleY: 0.8)
        let expectFrame = CGRect(x: screenFrame.width - config.distance, y: 0, width: config.distance, height: screenFrame.height)

        let height: CGFloat = screenFrame.height * config.scaleY
        let y: CGFloat = (screenFrame.height - height) / 2.0
        let expectFromFrame = CGRect(x: -config.distance, y: y, width: screenFrame.width, height: height)

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(presentedVC.exists)
        XCTAssertEqual(presentedVC.frame, expectFrame)
        XCTAssertEqual(fromVC.frame.origin, expectFromFrame.origin)

        app.tables/*@START_MENU_TOKEN@*/.cells.staticTexts["dismiss"]/*[[".cells.staticTexts[\"dismiss\"]",".staticTexts[\"dismiss\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        let expectMainFrame = CGRect(x: 0, y: 0, width: screenFrame.width, height: screenFrame.height)

        XCTAssertFalse(presentedVC.exists)
        XCTAssertEqual(fromVC.frame, expectMainFrame)
    }

    func testMaskFromLeftAndDismiss() throws {
        // UI tests must launch the application that they test.
        // Use recording to get started writing UI tests.
        let pushfromLeft = app.tables.cells.staticTexts["mask from left"]
        pushfromLeft.tap()

        let leftVC: XCUIElement = app.tables.containing(.other, identifier:"LeftViewController").element
        let fromVC = app.otherElements.matching(identifier: "TabBarController").element

        let screenFrame = app.frame
        let config = SlideDrawerConfiguration(animationType: .mask, direction: .left, distance: screenFrame.width * 0.85)
        let expectFrame = CGRect(x: 0, y: 0, width: config.distance, height: screenFrame.height)
        let expectFromFrame = screenFrame

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(leftVC.exists)
        XCTAssertEqual(leftVC.frame, expectFrame)
        XCTAssertEqual(fromVC.frame, expectFromFrame)

        app.tables/*@START_MENU_TOKEN@*/.cells.staticTexts["dismiss"]/*[[".cells.staticTexts[\"dismiss\"]",".staticTexts[\"dismiss\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()

        let expectMainFrame = CGRect(x: 0, y: 0, width: screenFrame.width, height: screenFrame.height)

        XCTAssertFalse(leftVC.exists)
        XCTAssertEqual(fromVC.frame, expectMainFrame)
    }

    func testMaskFromRightAndDismiss() throws {
        // UI tests must launch the application that they test.
        // Use recording to get started writing UI tests.
        let pushfromLeft = app.tables.cells.staticTexts["mask from right"]
        pushfromLeft.tap()

        let presentedVC: XCUIElement = app.tables.containing(.other, identifier:"RightViewController").element
        let fromVC = app.otherElements.matching(identifier: "TabBarController").element

        let screenFrame = app.frame
        let config = SlideDrawerConfiguration(animationType: .mask, direction: .right, distance: screenFrame.width * 0.75)
        let expectFrame = CGRect(x: screenFrame.width - config.distance, y: 0, width: config.distance, height: screenFrame.height)
        let expectFromFrame = screenFrame

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(presentedVC.exists)
        XCTAssertEqual(presentedVC.frame, expectFrame)
        XCTAssertEqual(fromVC.frame, expectFromFrame)

        app.tables/*@START_MENU_TOKEN@*/.cells.staticTexts["dismiss"]/*[[".cells.staticTexts[\"dismiss\"]",".staticTexts[\"dismiss\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()

        let expectMainFrame = screenFrame
        XCTAssertFalse(presentedVC.exists)
        XCTAssertEqual(fromVC.frame, expectMainFrame)
    }
//    func testAppearDuration() {
//        let tablesQuery = app.tables
//        let slider = tablesQuery.cells.containing(.staticText, identifier:"appearDuration").sliders["2%"]
//        slider.tap()
//        slider.tap()
//        tablesQuery.cells.containing(.staticText, identifier:"disappearDuration").sliders["2%"].tap()
//    }
}
