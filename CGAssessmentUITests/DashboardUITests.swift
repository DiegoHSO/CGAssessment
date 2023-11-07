//
//  DashboardUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 04/11/23.
//

import XCTest

final class DashboardUITests: XCTestCase {

    // MARK: - Life Cycle

    override func setUp() {
        super.setUp()

        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(pt-BR)"]
        app.launchArguments += ["-AppleLocale", "\"pt-BR\""]
        app.launchArguments += ["testMode"]
    }

    // MARK: - Test Methods

    func testLifeCycle() throws {
        let app = XCUIApplication()

        app.launch()

        guard app.tables["DashboardViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Dashboard tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["DashboardViewController-NoRecentApplicationTableViewCell"].exists)
        XCTAssertTrue(app.cells["DashboardViewController-FeaturesTableViewCell"].exists)
        XCTAssertTrue(app.cells["DashboardViewController-NoTodoEvaluationTableViewCell"].exists)
    }

    func testLifeCycleWithMockData() throws {
        let app = XCUIApplication()

        app.launchArguments += ["UITestMode"]
        app.launch()

        guard app.tables["DashboardViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Dashboard tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["DashboardViewController-RecentApplicationTableViewCell"].exists)
        XCTAssertTrue(app.cells["DashboardViewController-FeaturesTableViewCell"].exists)
        XCTAssertTrue(app.cells["DashboardViewController-TodoEvaluationTableViewCell-0"].exists)
    }

}
