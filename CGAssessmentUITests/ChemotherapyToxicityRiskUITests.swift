//
//  ChemotherapyToxicityRiskUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 05/11/23.
//

import XCTest

final class ChemotherapyToxicityRiskUITests: XCTestCase {

    // MARK: - Life Cycle

    override func setUp() {
        super.setUp()

        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(pt-BR)"]
        app.launchArguments += ["-AppleLocale", "\"pt-BR\""]
        app.launchArguments += ["testMode", "UITestMode"]

        app.launch()
    }

    // MARK: - Test Methods

    func testLifeCycle() throws {
        let app = XCUIApplication()

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

}
