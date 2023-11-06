//
//  ApgarScaleUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 05/11/23.
//

import XCTest

final class ApgarScaleUITests: XCTestCase {

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

        app.tables["CGADomainsViewController-tableView"].swipeUp(velocity: .fast)

        XCTAssertTrue(app.cells["CGADomainsViewController-CGADomainTableViewCell-5"].exists)
        app.cells["CGADomainsViewController-CGADomainTableViewCell-5"].tap()

        guard app.tables["SingleDomainViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("SingleDomain tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-0"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-0"].tap()

        guard app.tables["ApgarScaleViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("ApgarScale tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["ApgarScaleViewController-SelectableTableViewCell-0-0"].exists)
        XCTAssertTrue(app.cells["ApgarScaleViewController-ActionButtonTableViewCell"].exists)

        app.tables["ApgarScaleViewController-tableView"].swipeUp(velocity: .fast)
        app.tables["ApgarScaleViewController-tableView"].swipeUp(velocity: .fast)

        app.cells["ApgarScaleViewController-ActionButtonTableViewCell"].tap()

        guard app.tables["ResultsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Results tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].exists)
        app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].tap()
    }

}
