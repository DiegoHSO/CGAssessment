//
//  GripStrengthUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 05/11/23.
//

import XCTest

final class GripStrengthUITests: XCTestCase {

    func testLifeCycle() throws {
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

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-3"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-3"].tap()

        guard app.tables["GripStrengthViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("GripStrength tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["GripStrengthViewController-InstructionsTableViewCell"].exists)
        XCTAssertTrue(app.cells["GripStrengthViewController-ImageTableViewCell"].exists)
        XCTAssertTrue(app.cells["GripStrengthViewController-FirstTextFieldTableViewCell"].exists)
        XCTAssertTrue(app.cells["GripStrengthViewController-SecondTextFieldTableViewCell"].exists)
        XCTAssertTrue(app.cells["GripStrengthViewController-ThirdTextFieldTableViewCell"].exists)
        XCTAssertTrue(app.cells["GripStrengthViewController-ActionButtonTableViewCell"].exists)

        app.tables["GripStrengthViewController-tableView"].swipeUp(velocity: .fast)

        XCTAssertTrue(app.cells["GripStrengthViewController-ActionButtonTableViewCell"].isHittable)
        app.cells["GripStrengthViewController-ActionButtonTableViewCell"].tap()
    }

}
