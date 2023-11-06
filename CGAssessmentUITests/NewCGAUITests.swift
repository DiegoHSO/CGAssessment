//
//  NewCGAUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 04/11/23.
//

import XCTest

final class NewCGAUITests: XCTestCase {

    func testLifeCycleThroughDashboard() throws {
        let app = XCUIApplication()

        app.launchArguments = ["testMode", "UITestMode"]
        app.launch()

        guard app.tables["DashboardViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Dashboard tableView was not presented")
            return
        }

        XCTAssertTrue(app.buttons["FeaturesTableViewCell-FeatureComponentView-1"].exists)
        app.buttons["FeaturesTableViewCell-FeatureComponentView-1"].tap()

        guard app.tables["NewCGAViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("NewCGA tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["NewCGAViewController-ResumedPatientTableViewCell-0"].exists)
        app.cells["NewCGAViewController-ResumedPatientTableViewCell-0"].tap()

        let searchBarElement = app.searchFields.firstMatch

        searchBarElement.tap()
        searchBarElement.typeText("ttt")

        XCTAssertTrue(app.cells["NewCGAViewController-EmptyStateTableViewCell"].exists)

        app.cells["NewCGAViewController-SelectableTableViewCell-NoOption"].tap()

        XCTAssertTrue(app.cells["NewCGAViewController-TextFieldTableViewCell"].exists)
        XCTAssertTrue(app.cells["NewCGAViewController-SelectableTableViewCell-Gender"].exists)
        XCTAssertTrue(app.cells["NewCGAViewController-DatePickerTableViewCell"].exists)

        app.buttons["SelectableView-gender_key-1"].tap()

        let textField = app.textFields.firstMatch
        textField.tap()
        textField.typeText("Test patient")

        app.cells["NewCGAViewController-DatePickerTableViewCell"].tap()
    }

    func testLifeCycleThroughPatients() throws {
        let app = XCUIApplication()

        app.launchArguments = ["testMode"]
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

        XCTAssertTrue(app.cells["PatientsViewController-EmptyStateTableViewCell"].exists)
        app.cells["PatientsViewController-EmptyStateTableViewCell"].tap()

        guard app.tables["NewCGAViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("NewCGA tableView was not presented")
            return
        }

        app.cells["NewCGAViewController-SelectableTableViewCell-YesOption"].tap()

        XCTAssertTrue(app.cells["NewCGAViewController-EmptyStateTableViewCell"].exists)
        app.cells["NewCGAViewController-EmptyStateTableViewCell"].tap()

        XCTAssertTrue(app.cells["NewCGAViewController-TextFieldTableViewCell"].exists)
        XCTAssertTrue(app.cells["NewCGAViewController-SelectableTableViewCell-Gender"].exists)
        XCTAssertTrue(app.cells["NewCGAViewController-DatePickerTableViewCell"].exists)

        app.buttons["SelectableView-gender_key-1"].tap()

        let textField = app.textFields.firstMatch
        textField.tap()
        textField.typeText("Test patient")

        app.cells["NewCGAViewController-DatePickerTableViewCell"].tap()
    }

    func testLifeCycleThroughTabBar() throws {
        let app = XCUIApplication()

        app.launchArguments = ["testMode"]
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

        XCTAssertTrue(app.cells["CGAsViewController-EmptyStateTableViewCell"].exists)
        app.cells["CGAsViewController-EmptyStateTableViewCell"].tap()

        guard app.tables["NewCGAViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("NewCGA tableView was not presented")
            return
        }

        app.cells["NewCGAViewController-SelectableTableViewCell-YesOption"].tap()

        XCTAssertTrue(app.cells["NewCGAViewController-EmptyStateTableViewCell"].exists)
        app.cells["NewCGAViewController-EmptyStateTableViewCell"].tap()

        XCTAssertTrue(app.cells["NewCGAViewController-TextFieldTableViewCell"].exists)
        XCTAssertTrue(app.cells["NewCGAViewController-SelectableTableViewCell-Gender"].exists)
        XCTAssertTrue(app.cells["NewCGAViewController-DatePickerTableViewCell"].exists)

        app.buttons["SelectableView-gender_key-1"].tap()

        let textField = app.textFields.firstMatch
        textField.tap()
        textField.typeText("Test patient")

        app.cells["NewCGAViewController-DatePickerTableViewCell"].tap()
    }

}
