//
//  CGADomainsUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 04/11/23.
//

import XCTest

final class CGADomainsUITests: XCTestCase {

    func testLifeCycleThroughNewCGA() throws {
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

        XCTAssertTrue(app.cells["NewCGAViewController-ActionButtonTableViewCell"].exists)
        app.cells["NewCGAViewController-ActionButtonTableViewCell"].tap()

        guard app.tables["CGADomainsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("CGADomains tableView was not presented")
            return
        }

        XCTAssertTrue(app.buttons["CGADomainsViewController-infoButton"].exists)
        app.buttons["CGADomainsViewController-infoButton"].tap()

        app.tables["CGADomainsViewController-tableView"].swipeUp(velocity: .fast)
    }

    func testLifeCycleThroughCGADomains() throws {
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

        XCTAssertTrue(app.buttons["CGADomainsViewController-infoButton"].exists)
        app.buttons["CGADomainsViewController-infoButton"].tap()

        app.tables["CGADomainsViewController-tableView"].swipeUp(velocity: .fast)
    }

    func testLifeCycleThroughRecentApplication() throws {
        let app = XCUIApplication()

        app.launchArguments = ["testMode", "UITestMode"]
        app.launch()

        guard app.tables["DashboardViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Dashboard tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["DashboardViewController-RecentApplicationTableViewCell"].exists)
        app.cells["DashboardViewController-RecentApplicationTableViewCell"].tap()

        guard app.tables["CGADomainsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("CGADomains tableView was not presented")
            return
        }

        XCTAssertTrue(app.buttons["CGADomainsViewController-infoButton"].exists)
        app.buttons["CGADomainsViewController-infoButton"].tap()

        app.tables["CGADomainsViewController-tableView"].swipeUp(velocity: .fast)
    }

    func testLifeCycleThroughNoRecentApplication() throws {
        let app = XCUIApplication()

        app.launchArguments = ["testMode"]
        app.launch()

        guard app.tables["DashboardViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Dashboard tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["DashboardViewController-NoRecentApplicationTableViewCell"].exists)
        app.cells["DashboardViewController-NoRecentApplicationTableViewCell"].tap()

        guard app.tables["CGADomainsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("CGADomains tableView was not presented")
            return
        }

        XCTAssertTrue(app.buttons["CGADomainsViewController-infoButton"].exists)
        app.buttons["CGADomainsViewController-infoButton"].tap()

        app.tables["CGADomainsViewController-tableView"].swipeUp(velocity: .fast)
    }

    func testLifeCycleThroughEvaluationToReapply() throws {
        let app = XCUIApplication()

        app.launchArguments = ["testMode", "UITestMode"]
        app.launch()

        guard app.tables["DashboardViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Dashboard tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["DashboardViewController-TodoEvaluationTableViewCell-0"].exists)
        app.cells["DashboardViewController-TodoEvaluationTableViewCell-0"].tap()

        guard app.tables["CGADomainsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("CGADomains tableView was not presented")
            return
        }

        XCTAssertTrue(app.buttons["CGADomainsViewController-infoButton"].exists)
        app.buttons["CGADomainsViewController-infoButton"].tap()

        app.tables["CGADomainsViewController-tableView"].swipeUp(velocity: .fast)
    }

    func testLifeCycleThroughPatientCGAs() throws {
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

        XCTAssertTrue(app.cells["CGAsViewController-CGATableViewCell-0"].exists)
        app.cells["CGAsViewController-CGATableViewCell-0"].tap()

        guard app.tables["CGADomainsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("CGADomains tableView was not presented")
            return
        }

        XCTAssertTrue(app.buttons["CGADomainsViewController-infoButton"].exists)
        app.buttons["CGADomainsViewController-infoButton"].tap()

        app.tables["CGADomainsViewController-tableView"].swipeUp(velocity: .fast)
    }

    func testLifeCycleThroughCGAs() throws {
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

        XCTAssertTrue(app.cells["CGAsViewController-CGATableViewCell-0"].exists)
        app.cells["CGAsViewController-CGATableViewCell-0"].tap()

        guard app.tables["CGADomainsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("CGADomains tableView was not presented")
            return
        }

        XCTAssertTrue(app.buttons["CGADomainsViewController-infoButton"].exists)
        app.buttons["CGADomainsViewController-infoButton"].tap()

        app.tables["CGADomainsViewController-tableView"].swipeUp(velocity: .fast)
    }

}
