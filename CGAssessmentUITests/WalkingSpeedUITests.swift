//
//  WalkingSpeedUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 04/11/23.
//

import XCTest

final class WalkingSpeedUITests: XCTestCase {

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

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-1"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-1"].tap()

        guard app.tables["WalkingSpeedViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("WalkingSpeed tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["WalkingSpeedViewController-InstructionsTableViewCell"].exists)
        XCTAssertTrue(app.cells["WalkingSpeedViewController-SelectableTableViewCell-hasStopwatch"].exists)
        XCTAssertTrue(app.cells["WalkingSpeedViewController-SelectableTableViewCell-doesNotHaveStopwatch"].exists)
        XCTAssertTrue(app.cells["WalkingSpeedViewController-ThirdStopwatchTableViewCell"].exists)
        XCTAssertTrue(app.cells["WalkingSpeedViewController-FirstTooltipTableViewCell"].exists)
        XCTAssertTrue(app.cells["WalkingSpeedViewController-SecondTooltipTableViewCell"].exists)
        XCTAssertTrue(app.cells["WalkingSpeedViewController-ThirdTooltipTableViewCell"].exists)
        XCTAssertTrue(app.cells["WalkingSpeedViewController-ActionButtonTableViewCell"].exists)

        XCTAssertTrue(app.buttons["StopwatchTableViewCell-LeftButton"].exists)
        XCTAssertTrue(app.buttons["StopwatchTableViewCell-RightButton"].exists)

        app.buttons["StopwatchTableViewCell-LeftButton"].tap()
        app.buttons["StopwatchTableViewCell-RightButton"].tap()

        app.cells["WalkingSpeedViewController-FirstTooltipTableViewCell"].tap()

        XCTAssertTrue(app.buttons["StopwatchTableViewCell-LeftButton"].exists)
        XCTAssertTrue(app.buttons["StopwatchTableViewCell-RightButton"].exists)

        app.buttons["StopwatchTableViewCell-LeftButton"].tap()
        app.buttons["StopwatchTableViewCell-RightButton"].tap()

        app.cells["WalkingSpeedViewController-SecondTooltipTableViewCell"].tap()

        XCTAssertTrue(app.buttons["StopwatchTableViewCell-LeftButton"].exists)
        XCTAssertTrue(app.buttons["StopwatchTableViewCell-RightButton"].exists)

        app.buttons["StopwatchTableViewCell-LeftButton"].tap()
        app.buttons["StopwatchTableViewCell-RightButton"].tap()

        app.cells["WalkingSpeedViewController-ThirdTooltipTableViewCell"].tap()

        app.cells["WalkingSpeedViewController-SelectableTableViewCell-hasStopwatch"].tap()
        XCTAssertTrue(app.cells["WalkingSpeedViewController-FirstTextFieldTableViewCell"].exists)
        XCTAssertTrue(app.cells["WalkingSpeedViewController-SecondTextFieldTableViewCell"].exists)
        XCTAssertTrue(app.cells["WalkingSpeedViewController-ThirdTextFieldTableViewCell"].exists)

        app.tables["WalkingSpeedViewController-tableView"].swipeUp(velocity: .fast)

        XCTAssertTrue(app.cells["WalkingSpeedViewController-ActionButtonTableViewCell"].isHittable)
        app.cells["WalkingSpeedViewController-ActionButtonTableViewCell"].tap()

        guard app.tables["ResultsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Results tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].exists)
        app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].tap()
    }

}
