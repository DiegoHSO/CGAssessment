//
//  TimedUpAndGoUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 04/11/23.
//

import XCTest

final class TimedUpAndGoUITests: XCTestCase {

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

        XCTAssertTrue(app.cells["CGADomainsViewController-CGADomainTableViewCell-0"].exists)
        app.cells["CGADomainsViewController-CGADomainTableViewCell-0"].tap()

        guard app.tables["SingleDomainViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("SingleDomain tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-0"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-0"].tap()

        guard app.tables["TimedUpAndGoViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("TimedUpAndGo tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["TimedUpAndGoViewController-InstructionsTableViewCell"].exists)
        XCTAssertTrue(app.cells["TimedUpAndGoViewController-SelectableTableViewCell-hasStopwatch"].exists)
        XCTAssertTrue(app.cells["TimedUpAndGoViewController-SelectableTableViewCell-doesNotHaveStopwatch"].exists)
        XCTAssertTrue(app.cells["TimedUpAndGoViewController-StopwatchTableViewCell"].exists)
        XCTAssertTrue(app.cells["TimedUpAndGoViewController-ActionButtonTableViewCell"].exists)

        XCTAssertTrue(app.buttons["StopwatchTableViewCell-LeftButton"].exists)
        XCTAssertTrue(app.buttons["StopwatchTableViewCell-RightButton"].exists)

        app.buttons["StopwatchTableViewCell-LeftButton"].tap()
        app.buttons["StopwatchTableViewCell-RightButton"].tap()

        app.cells["TimedUpAndGoViewController-SelectableTableViewCell-hasStopwatch"].tap()
        XCTAssertTrue(app.cells["TimedUpAndGoViewController-TextFieldTableViewCell"].exists)

        app.tables["TimedUpAndGoViewController-tableView"].swipeUp(velocity: .fast)

        XCTAssertTrue(app.cells["TimedUpAndGoViewController-ActionButtonTableViewCell"].isHittable)
        app.cells["TimedUpAndGoViewController-ActionButtonTableViewCell"].tap()

        guard app.tables["ResultsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Results tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].exists)
        app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].tap()
    }

}
