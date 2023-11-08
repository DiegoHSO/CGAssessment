//
//  HearingLossAssessmentUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 05/11/23.
//

import XCTest

final class HearingLossAssessmentUITests: XCTestCase {

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

        XCTAssertTrue(app.cells["CGADomainsViewController-CGADomainTableViewCell-2"].exists)
        app.cells["CGADomainsViewController-CGADomainTableViewCell-2"].tap()

        guard app.tables["SingleDomainViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("SingleDomain tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-1"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-1"].tap()

        guard app.tables["HearingLossAssessmentViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("HearingLossAssessment tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["HearingLossAssessmentViewController-TooltipTableViewCell"].exists)
        XCTAssertTrue(app.cells["HearingLossAssessmentViewController-InstructionsTableViewCell"].exists)
        XCTAssertTrue(app.cells["HearingLossAssessmentViewController-ActionButtonTableViewCell"].exists)

        app.tables["HearingLossAssessmentViewController-tableView"].swipeUp(velocity: .fast)

        app.cells["HearingLossAssessmentViewController-ActionButtonTableViewCell"].tap()
    }

}
