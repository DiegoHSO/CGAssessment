//
//  VerbalFluencyUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 05/11/23.
//

import XCTest

final class VerbalFluencyUITests: XCTestCase {

    // MARK: - Life Cycle

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

        XCTAssertTrue(app.cells["CGADomainsViewController-CGADomainTableViewCell-1"].exists)
        app.cells["CGADomainsViewController-CGADomainTableViewCell-1"].tap()

        guard app.tables["SingleDomainViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("SingleDomain tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-1"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-1"].tap()

        guard app.tables["VerbalFluencyViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("VerbalFluency tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["VerbalFluencyViewController-InstructionsTableViewCell"].exists)
        XCTAssertTrue(app.cells["VerbalFluencyViewController-StopwatchTableViewCell"].exists)
        XCTAssertTrue(app.cells["VerbalFluencyViewController-StepperTableViewCell"].exists)
        XCTAssertTrue(app.cells["VerbalFluencyViewController-SelectableTableViewCell"].exists)
        XCTAssertTrue(app.cells["VerbalFluencyViewController-ActionButtonTableViewCell"].exists)

        XCTAssertTrue(app.buttons["StopwatchTableViewCell-LeftButton"].exists)
        XCTAssertTrue(app.buttons["StopwatchTableViewCell-RightButton"].exists)

        app.buttons["StopwatchTableViewCell-LeftButton"].tap()
        app.buttons["StopwatchTableViewCell-RightButton"].tap()

        app.tables["VerbalFluencyViewController-tableView"].swipeUp(velocity: .fast)

        app.buttons["Increment"].firstMatch.tap()
        app.buttons["Decrement"].firstMatch.tap()

        XCTAssertTrue(app.cells["VerbalFluencyViewController-ActionButtonTableViewCell"].isHittable)
        app.cells["VerbalFluencyViewController-ActionButtonTableViewCell"].tap()

        guard app.tables["ResultsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Results tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].exists)
        app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].tap()
    }

}
