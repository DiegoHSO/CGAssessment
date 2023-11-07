//
//  CharlsonIndexUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 05/11/23.
//

import XCTest

final class CharlsonIndexUITests: XCTestCase {

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
        app.tables["CGADomainsViewController-tableView"].swipeUp(velocity: .fast)

        XCTAssertTrue(app.cells["CGADomainsViewController-CGADomainTableViewCell-7"].exists)
        app.cells["CGADomainsViewController-CGADomainTableViewCell-7"].tap()

        guard app.tables["SingleDomainViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("SingleDomain tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-0"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-0"].tap()

        guard app.tables["CharlsonIndexViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("CharlsonIndex tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["CharlsonIndexViewController-BinaryOptionsTableViewCell-0-0"].exists)
        XCTAssertTrue(app.cells["CharlsonIndexViewController-ActionButtonTableViewCell"].exists)

        app.tables["CharlsonIndexViewController-tableView"].swipeUp(velocity: .fast)
        app.tables["CharlsonIndexViewController-tableView"].swipeUp(velocity: .fast)

        XCTAssertTrue(app.cells["CharlsonIndexViewController-ActionButtonTableViewCell"].isHittable)
        app.cells["CharlsonIndexViewController-ActionButtonTableViewCell"].tap()

        guard app.tables["ResultsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Results tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].exists)
        app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].tap()
    }

}
