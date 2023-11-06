//
//  SarcopeniaScreeningUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 05/11/23.
//

import XCTest

final class SarcopeniaScreeningUITests: XCTestCase {

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

        XCTAssertTrue(app.cells["CGADomainsViewController-CGADomainTableViewCell-0"].exists)
        app.cells["CGADomainsViewController-CGADomainTableViewCell-0"].tap()

        guard app.tables["SingleDomainViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("SingleDomain tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-4"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-4"].tap()

        guard app.tables["SarcopeniaScreeningViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("SarcopeniaScreening tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["SarcopeniaScreeningViewController-SelectableTableViewCell-0-0"].exists)
        XCTAssertTrue(app.cells["SarcopeniaScreeningViewController-ActionButtonTableViewCell"].exists)

        app.tables["SarcopeniaScreeningViewController-tableView"].swipeUp(velocity: .fast)

        app.cells["SarcopeniaScreeningViewController-ActionButtonTableViewCell"].tap()
    }

}
