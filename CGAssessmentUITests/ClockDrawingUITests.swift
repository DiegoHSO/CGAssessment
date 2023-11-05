//
//  ClockDrawingUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 05/11/23.
//

import XCTest

final class ClockDrawingUITests: XCTestCase {

    func testLifeCycle() throws {
        let app = XCUIApplication()

        app.launchArguments = ["testMode", "UITestMode"]
        app.launch()

        guard app.tables["DashboardViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Dashboard tableView was not presented")
            return
        }

        XCTAssertTrue(app.buttons["FeaturesTableViewCell-FeatureComponentView-3"].exists)
        app.buttons["FeaturesTableViewCell-FeatureComponentView-3"].tap()

        guard app.tables["CGADomainsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("CGADomains tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["CGADomainsViewController-CGADomainTableViewCell-1"].exists)
        app.cells["CGADomainsViewController-CGADomainTableViewCell-1"].tap()

        guard app.tables["SingleDomainViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("SingleDomain tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-2"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-2"].tap()

        guard app.tables["ClockDrawingViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("ClockDrawing tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["ClockDrawingViewController-InstructionsTableViewCell"].exists)
        XCTAssertTrue(app.cells["ClockDrawingViewController-BinaryOptionsTableViewCell-1-0"].exists)
        XCTAssertTrue(app.cells["ClockDrawingViewController-ActionButtonTableViewCell"].exists)

        app.tables["ClockDrawingViewController-tableView"].swipeUp(velocity: .fast)
        app.tables["ClockDrawingViewController-tableView"].swipeUp(velocity: .fast)

        XCTAssertTrue(app.cells["ClockDrawingViewController-ActionButtonTableViewCell"].isHittable)
        app.cells["ClockDrawingViewController-ActionButtonTableViewCell"].tap()
    }

}
