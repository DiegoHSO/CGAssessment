//
//  MiniNutritionalAssessmentUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 05/11/23.
//

import XCTest

final class MiniNutritionalAssessmentUITests: XCTestCase {

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

        app.tables["CGADomainsViewController-tableView"].swipeUp(velocity: .slow)

        XCTAssertTrue(app.cells["CGADomainsViewController-CGADomainTableViewCell-4"].exists)
        app.cells["CGADomainsViewController-CGADomainTableViewCell-4"].tap()

        guard app.tables["SingleDomainViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("SingleDomain tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-0"].exists)
        app.cells["SingleDomainViewController-TestTableViewCell-0"].tap()

        guard app.tables["MiniNutritionalAssessmentViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("MiniNutritionalAssessment tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["MiniNutritionalAssessmentViewController-SelectableTableViewCell-0-0"].exists)
        XCTAssertTrue(app.cells["MiniNutritionalAssessmentViewController-TooltipTableViewCell"].exists)
        XCTAssertTrue(app.cells["MiniNutritionalAssessmentViewController-SheetableTableViewCell-0"].exists)
        XCTAssertTrue(app.cells["MiniNutritionalAssessmentViewController-SheetableTableViewCell-1"].exists)
        XCTAssertTrue(app.cells["MiniNutritionalAssessmentViewController-ActionButtonTableViewCell"].exists)

        app.tables["MiniNutritionalAssessmentViewController-tableView"].swipeUp(velocity: .fast)

        XCTAssertTrue(app.buttons["SheetableTableViewCell-height_key"].exists)
        app.buttons["SheetableTableViewCell-height_key"].tap()

        XCTAssertTrue(app.pickerWheels.firstMatch.exists)
        app.pickerWheels.firstMatch.adjust(toPickerWheelValue: "170 cm")

        XCTAssertTrue(app.cells["MiniNutritionalAssessmentViewController-SelectableTableViewCell-0-3"].exists)
        app.cells["MiniNutritionalAssessmentViewController-SelectableTableViewCell-0-3"].tap()

        app.tables["MiniNutritionalAssessmentViewController-tableView"].swipeUp(velocity: .fast)

        XCTAssertTrue(app.buttons["SheetableTableViewCell-weight_key"].exists)
        app.buttons["SheetableTableViewCell-weight_key"].tap()

        XCTAssertTrue(app.pickerWheels.firstMatch.exists)
        app.pickerWheels.firstMatch.adjust(toPickerWheelValue: "79 kg")

        XCTAssertTrue(app.cells["MiniNutritionalAssessmentViewController-SelectableTableViewCell-0-3"].exists)
        app.cells["MiniNutritionalAssessmentViewController-SelectableTableViewCell-0-3"].tap()

        XCTAssertTrue(app.cells["MiniNutritionalAssessmentViewController-TooltipTableViewCell"].exists)
        app.cells["MiniNutritionalAssessmentViewController-TooltipTableViewCell"].tap()

        app.tables["MiniNutritionalAssessmentViewController-tableView"].swipeUp(velocity: .fast)

        XCTAssertTrue(app.cells["MiniNutritionalAssessmentViewController-SelectableTableViewCell-3-0"].exists)
        app.buttons["SelectableView-mini_nutritional_assessment_seventh_question_key-1"].tap()

        app.tables["MiniNutritionalAssessmentViewController-tableView"].swipeUp(velocity: .fast)

        XCTAssertTrue(app.cells["MiniNutritionalAssessmentViewController-ActionButtonTableViewCell"].exists)
        app.cells["MiniNutritionalAssessmentViewController-ActionButtonTableViewCell"].tap()

        guard app.tables["ResultsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Results tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].exists)
        app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].tap()
    }

}
