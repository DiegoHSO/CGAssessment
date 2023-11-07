//
//  LawtonScaleUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 05/11/23.
//

import XCTest

final class LawtonScaleUITests: XCTestCase {

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

        app.tables["CGADomainsViewController-tableView"].swipeUp(velocity: .slow)

        XCTAssertTrue(app.cells["CGADomainsViewController-CGADomainTableViewCell-3"].exists)
        app.cells["CGADomainsViewController-CGADomainTableViewCell-3"].tap()

        guard app.tables["SingleDomainViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("SingleDomain tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-1"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-1"].tap()

        guard app.tables["LawtonScaleViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("LawtonScale tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["LawtonScaleViewController-SelectableTableViewCell-1-0"].exists)
        XCTAssertTrue(app.cells["LawtonScaleViewController-ActionButtonTableViewCell"].exists)

        app.tables["LawtonScaleViewController-tableView"].swipeUp(velocity: .fast)
        app.tables["LawtonScaleViewController-tableView"].swipeUp(velocity: .fast)

        app.cells["LawtonScaleViewController-ActionButtonTableViewCell"].tap()

        guard app.tables["ResultsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Results tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].exists)
        app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].tap()
    }

}
