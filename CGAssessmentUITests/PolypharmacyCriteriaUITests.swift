//
//  PolypharmacyCriteriaUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 05/11/23.
//

import XCTest

final class PolypharmacyCriteriaUITests: XCTestCase {

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

        app.tables["CGADomainsViewController-tableView"].swipeUp(velocity: .fast)

        XCTAssertTrue(app.cells["CGADomainsViewController-CGADomainTableViewCell-6"].exists)
        app.cells["CGADomainsViewController-CGADomainTableViewCell-6"].tap()

        guard app.tables["SingleDomainViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("SingleDomain tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-0"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-0"].tap()

        guard app.tables["PolypharmacyCriteriaViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("PolypharmacyCriteria tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["PolypharmacyCriteriaViewController-InstructionsTableViewCell"].exists)
        XCTAssertTrue(app.cells["PolypharmacyCriteriaViewController-SheetableTableViewCell"].exists)
        XCTAssertTrue(app.cells["PolypharmacyCriteriaViewController-ActionButtonTableViewCell"].exists)

        XCTAssertTrue(app.buttons["SheetableTableViewCell-number_of_medicines_key"].exists)
        app.buttons["SheetableTableViewCell-number_of_medicines_key"].tap()

        XCTAssertTrue(app.pickerWheels.firstMatch.exists)
        app.pickerWheels.firstMatch.adjust(toPickerWheelValue: "6 medicamentos")

        XCTAssertTrue(app.cells["PolypharmacyCriteriaViewController-InstructionsTableViewCell"].exists)
        app.cells["PolypharmacyCriteriaViewController-InstructionsTableViewCell"].tap()

        XCTAssertTrue(app.cells["PolypharmacyCriteriaViewController-ActionButtonTableViewCell"].exists)
        app.cells["PolypharmacyCriteriaViewController-ActionButtonTableViewCell"].tap()
    }

}
