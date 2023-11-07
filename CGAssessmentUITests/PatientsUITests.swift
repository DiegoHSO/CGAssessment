//
//  PatientsUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 04/11/23.
//

import XCTest

final class PatientsUITests: XCTestCase {

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

        XCTAssertTrue(app.cells["PatientsViewController-FilterTableViewCell"].exists)

        app.cells["PatientsViewController-FilterTableViewCell"].tap()
        app.buttons["UIAction-Maior idade"].tap()

        XCTAssertTrue(app.cells["PatientsViewController-EmptyStateTableViewCell"].exists)
    }

    func testLifeCycleWithMockData() throws {
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

        XCTAssertTrue(app.cells["PatientsViewController-FilterTableViewCell"].exists)

        app.cells["PatientsViewController-FilterTableViewCell"].tap()
        app.buttons["UIAction-Maior idade"].tap()

        XCTAssertTrue(app.cells["PatientsViewController-PatientTableViewCell-0"].exists)

        app.cells["PatientsViewController-PatientTableViewCell-0"].swipeLeft(velocity: .fast)
        app.cells["PatientsViewController-PatientTableViewCell-0"].buttons["Apagar"].tap()
        app.buttons["PatientsViewController-deleteAction"].tap()

        XCTAssertFalse(app.cells["PatientsViewController-PatientTableViewCell-0"].exists)
    }

    func testLifeCycleWithMockDataAndSearch() throws {
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

        XCTAssertTrue(app.cells["PatientsViewController-FilterTableViewCell"].exists)

        app.cells["PatientsViewController-FilterTableViewCell"].tap()
        app.buttons["UIAction-Maior idade"].tap()

        XCTAssertTrue(app.cells["PatientsViewController-PatientTableViewCell-0"].exists)

        let searchBarElement = app.searchFields.firstMatch

        searchBarElement.tap()
        searchBarElement.typeText("ttt")

        XCTAssertTrue(app.cells["PatientsViewController-EmptyStateTableViewCell"].exists)
    }

}
