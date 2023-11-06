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

        XCTAssertTrue(app.cells["SarcopeniaScreeningViewController-SelectableTableViewCell-1-0"].exists)
        XCTAssertTrue(app.cells["SarcopeniaScreeningViewController-ActionButtonTableViewCell"].exists)

        app.tables["SarcopeniaScreeningViewController-tableView"].swipeUp(velocity: .fast)

        app.cells["SarcopeniaScreeningViewController-ActionButtonTableViewCell"].tap()

        guard app.tables["ResultsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Results tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].exists)
        app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].tap()
    }

    func testLifeCycleWithGoodResult() throws {
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

        app.buttons["SelectableView-sarcopenia_assessment_first_question_key-1"].tap()
        app.buttons["SelectableView-sarcopenia_assessment_second_question_key-1"].tap()
        app.buttons["SelectableView-sarcopenia_assessment_third_question_key-1"].tap()

        app.tables["SarcopeniaScreeningViewController-tableView"].swipeUp(velocity: .fast)

        app.buttons["SelectableView-sarcopenia_assessment_fourth_question_key-1"].tap()
        app.buttons["SelectableView-sarcopenia_assessment_fifth_question_key-1"].tap()
        app.buttons["SelectableView-sarcopenia_assessment_sixth_question_key-1"].tap()

        app.cells["SarcopeniaScreeningViewController-ActionButtonTableViewCell"].tap()

        guard app.tables["ResultsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Results tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].exists)
        app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].tap()
    }

}
