//
//  SuspectedAbuseUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 05/11/23.
//

import XCTest

final class SuspectedAbuseUITests: XCTestCase {

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
        app.tables["CGADomainsViewController-tableView"].swipeUp(velocity: .fast)

        XCTAssertTrue(app.cells["CGADomainsViewController-CGADomainTableViewCell-8"].exists)
        app.cells["CGADomainsViewController-CGADomainTableViewCell-8"].tap()

        guard app.tables["SingleDomainViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("SingleDomain tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-0"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-0"].tap()

        guard app.tables["SuspectedAbuseViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("SuspectedAbuse tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["SuspectedAbuseViewController-SelectableTableViewCell-yesOption"].exists)
        XCTAssertTrue(app.cells["SuspectedAbuseViewController-SelectableTableViewCell-noOption"].exists)
        XCTAssertTrue(app.cells["SuspectedAbuseViewController-TextViewTableViewCell"].exists)
        XCTAssertTrue(app.cells["SuspectedAbuseViewController-ActionButtonTableViewCell"].exists)

        XCTAssertTrue(app.textViews.firstMatch.exists)
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText("Inserting test text. ")

        app.cells["SuspectedAbuseViewController-SelectableTableViewCell-noOption"].tap()
        XCTAssertTrue(app.cells["SuspectedAbuseViewController-ActionButtonTableViewCell"].exists)

        app.cells["SuspectedAbuseViewController-ActionButtonTableViewCell"].tap()
    }

}
