//
//  CGAsUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 04/11/23.
//

import XCTest

final class CGAsUITests: XCTestCase {

    // MARK: - Test Methods

    func testLifeCycleThroughDashboard() throws {
        let app = XCUIApplication()

        app.launchArguments = ["testMode"]
        app.launch()

        guard app.tables["DashboardViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Dashboard tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["DashboardViewController-NoTodoEvaluationTableViewCell"].exists)

        app.buttons["NoTodoEvaluationTableViewCell-callToActionButton"].tap()

        guard app.tables["CGAsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("CGAs tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["CGAsViewController-FilterTableViewCell"].exists)
        XCTAssertTrue(app.buttons["CGAsViewController-infoButton"].exists)

        app.cells["CGAsViewController-FilterTableViewCell"].tap()
        app.buttons["UIAction-Paciente"].tap()

        app.buttons["CGAsViewController-infoButton"].tap()

        XCTAssertTrue(app.cells["CGAsViewController-EmptyStateTableViewCell"].exists)
    }

    func testLifeCycleThroughPatients() throws {
        let app = XCUIApplication()

        app.launchArguments = ["testMode", "UITestMode"]
        app.launch()

        guard app.tables["DashboardViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Dashboard tableView was not presented")
            return
        }

        XCTAssertTrue(app.buttons["FeaturesTableViewCell-FeatureComponentView-2"].exists)
        app.buttons["FeaturesTableViewCell-FeatureComponentView-2"].tap()

        guard app.tables["PatientsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Patients tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["PatientsViewController-PatientTableViewCell-0"].exists)
        app.cells["PatientsViewController-PatientTableViewCell-0"].tap()

        guard app.tables["CGAsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("CGAs tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["CGAsViewController-FilterTableViewCell"].exists)
        XCTAssertTrue(app.buttons["CGAsViewController-infoButton"].exists)

        app.cells["CGAsViewController-FilterTableViewCell"].tap()
        app.buttons["UIAction-Mais antigo"].tap()

        app.buttons["CGAsViewController-infoButton"].tap()

        XCTAssertTrue(app.cells["CGAsViewController-CGATableViewCell-0"].exists)

        app.cells["CGAsViewController-CGATableViewCell-0"].swipeLeft(velocity: .fast)
        app.cells["CGAsViewController-CGATableViewCell-0"].buttons["Apagar"].tap()
        app.buttons["CGAsViewController-deleteAction"].tap()

        XCTAssertFalse(app.cells["CGAsViewController-CGATableViewCell-0"].exists)
    }

    func testLifeCycleThroughTabBar() throws {
        let app = XCUIApplication()

        app.launchArguments = ["testMode", "UITestMode"]
        app.launch()

        guard app.tabBars["TabBarViewController-TabBar"].waitForExistence(timeout: 10) else {
            XCTFail("Tab bar was not presented")
            return
        }

        app.tabBars.buttons.element(boundBy: 1).tap()

        guard app.tables["CGAsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("CGAs tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["CGAsViewController-FilterTableViewCell"].exists)
        XCTAssertTrue(app.buttons["CGAsViewController-infoButton"].exists)

        app.cells["CGAsViewController-FilterTableViewCell"].tap()
        app.buttons["UIAction-Paciente"].tap()

        app.buttons["CGAsViewController-infoButton"].tap()

        XCTAssertTrue(app.cells["CGAsViewController-CGATableViewCell-0"].exists)

        app.cells["CGAsViewController-CGATableViewCell-0"].swipeLeft(velocity: .fast)
        app.cells["CGAsViewController-CGATableViewCell-0"].buttons["Apagar"].tap()
        app.buttons["CGAsViewController-deleteAction"].tap()

        XCTAssertFalse(app.cells["CGAsViewController-CGATableViewCell-0"].exists)
    }

}
