//
//  SarcopeniaAssessmentUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 05/11/23.
//

import XCTest

final class SarcopeniaAssessmentUITests: XCTestCase {

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

        XCTAssertTrue(app.cells["SarcopeniaScreeningViewController-SelectableTableViewCell-1-0"].exists)
        XCTAssertTrue(app.cells["SarcopeniaScreeningViewController-ActionButtonTableViewCell"].exists)

        app.tables["SarcopeniaScreeningViewController-tableView"].swipeUp(velocity: .fast)

        app.cells["SarcopeniaScreeningViewController-ActionButtonTableViewCell"].tap()

        guard app.tables["ResultsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Results tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["ResultsViewController-ResultsTableViewCell"].exists)
        XCTAssertTrue(app.cells["ResultsViewController-TitleTableViewCell"].exists)
        XCTAssertTrue(app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].exists)
        XCTAssertTrue(app.cells["ResultsViewController-ActionButtonTableViewCell-goBack"].exists)

        app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].tap()

        guard app.tables["SarcopeniaAssessmentViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("SarcopeniaAssessment tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["SarcopeniaAssessmentViewController-Title"].exists)
        XCTAssertTrue(app.cells["SarcopeniaAssessmentViewController-TestTableViewCell-1-0"].exists)
        XCTAssertTrue(app.cells["SarcopeniaAssessmentViewController-TestTableViewCell-2-0"].exists)
        XCTAssertTrue(app.cells["SarcopeniaAssessmentViewController-TestTableViewCell-3-0"].exists)
        XCTAssertFalse(app.cells["SarcopeniaAssessmentViewController-ActionButtonTableViewCell"].exists)

        app.tables["SarcopeniaAssessmentViewController-tableView"].swipeUp(velocity: .fast)
    }

}
