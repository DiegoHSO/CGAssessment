//
//  GeriatricDepressionScaleUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 05/11/23.
//

import XCTest

final class GeriatricDepressionScaleUITests: XCTestCase {

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

        XCTAssertTrue(app.cells["CGADomainsViewController-CGADomainTableViewCell-1"].exists)
        app.cells["CGADomainsViewController-CGADomainTableViewCell-1"].tap()

        guard app.tables["SingleDomainViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("SingleDomain tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-4"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-4"].tap()

        guard app.tables["GeriatricDepressionScaleViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("GeriatricDepressionScale tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["GeriatricDepressionScaleViewController-SelectableTableViewCell-0"].exists)
        XCTAssertTrue(app.cells["GeriatricDepressionScaleViewController-ActionButtonTableViewCell"].exists)

        app.tables["GeriatricDepressionScaleViewController-tableView"].swipeUp(velocity: .fast)
        app.tables["GeriatricDepressionScaleViewController-tableView"].swipeUp(velocity: .fast)
        app.tables["GeriatricDepressionScaleViewController-tableView"].swipeUp(velocity: .fast)

        XCTAssertTrue(app.cells["GeriatricDepressionScaleViewController-ActionButtonTableViewCell"].isHittable)
        app.cells["GeriatricDepressionScaleViewController-ActionButtonTableViewCell"].tap()
    }
}
