//
//  CalfCircumferenceUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 04/11/23.
//

import XCTest

final class CalfCircumferenceUITests: XCTestCase {

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

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-2"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-2"].tap()

        guard app.tables["CalfCircumferenceViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("CalfCircumference tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["CalfCircumferenceViewController-InstructionsTableViewCell"].exists)
        XCTAssertTrue(app.cells["CalfCircumferenceViewController-ImageTableViewCell"].exists)
        XCTAssertTrue(app.cells["CalfCircumferenceViewController-TextFieldTableViewCell"].exists)
        XCTAssertTrue(app.cells["CalfCircumferenceViewController-ActionButtonTableViewCell"].exists)

        app.tables["CalfCircumferenceViewController-tableView"].swipeUp(velocity: .fast)

        XCTAssertTrue(app.cells["CalfCircumferenceViewController-ActionButtonTableViewCell"].isHittable)
        app.cells["CalfCircumferenceViewController-ActionButtonTableViewCell"].tap()

        guard app.tables["ResultsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Results tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].exists)
        app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].tap()
    }

}
