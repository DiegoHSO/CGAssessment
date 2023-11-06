//
//  ResultsUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 05/11/23.
//

import XCTest

final class ResultsUITests: XCTestCase {

    func testLifeCycleInSpecialFlow() throws {
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
    }

    func testLifeCycleInLastAssessment() throws {
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

        XCTAssertTrue(app.cells["CGADomainsViewController-CGADomainTableViewCell-8"].exists)
        app.cells["CGADomainsViewController-CGADomainTableViewCell-8"].tap()

        guard app.tables["SingleDomainViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("SingleDomain tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-1"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-1"].tap()

        guard app.tables["ChemotherapyToxicityRiskViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("ChemotherapyToxicityRisk tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["ChemotherapyToxicityRiskViewController-SelectableTableViewCell-0-0"].exists)
        XCTAssertTrue(app.cells["ChemotherapyToxicityRiskViewController-ActionButtonTableViewCell"].exists)

        app.tables["ChemotherapyToxicityRiskViewController-tableView"].swipeUp(velocity: .fast)
        app.tables["ChemotherapyToxicityRiskViewController-tableView"].swipeUp(velocity: .fast)

        app.cells["ChemotherapyToxicityRiskViewController-ActionButtonTableViewCell"].tap()

        guard app.tables["ResultsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Results tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["ResultsViewController-ResultsTableViewCell"].exists)
        XCTAssertTrue(app.cells["ResultsViewController-ActionButtonTableViewCell-goBack"].exists)
        XCTAssertFalse(app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].exists)
        XCTAssertFalse(app.cells["ResultsViewController-TitleTableViewCell"].exists)

        app.cells["ResultsViewController-ActionButtonTableViewCell-goBack"].tap()
    }

    func testLifeCycleInDefaultFlow() throws {
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

        app.tables["CGADomainsViewController-tableView"].swipeUp(velocity: .slow)

        XCTAssertTrue(app.cells["CGADomainsViewController-CGADomainTableViewCell-3"].exists)
        app.cells["CGADomainsViewController-CGADomainTableViewCell-3"].tap()

        guard app.tables["SingleDomainViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("SingleDomain tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-0"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-0"].tap()

        guard app.tables["KatzScaleViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("KatzScale tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["KatzScaleViewController-SelectableTableViewCell-1-0"].exists)
        XCTAssertTrue(app.cells["KatzScaleViewController-ActionButtonTableViewCell"].exists)

        app.tables["KatzScaleViewController-tableView"].swipeUp(velocity: .fast)

        app.cells["KatzScaleViewController-ActionButtonTableViewCell"].tap()

        guard app.tables["ResultsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Results tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["ResultsViewController-ResultsTableViewCell"].exists)
        XCTAssertTrue(app.cells["ResultsViewController-ActionButtonTableViewCell-goBack"].exists)
        XCTAssertTrue(app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].exists)
        XCTAssertFalse(app.cells["ResultsViewController-TitleTableViewCell"].exists)

        app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].tap()
    }

}
