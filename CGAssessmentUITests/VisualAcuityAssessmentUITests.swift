//
//  VisualAcuityAssessmentUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 05/11/23.
//

import XCTest

final class VisualAcuityAssessmentUITests: XCTestCase {

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

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-0"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-0"].tap()

        guard app.tables["VisualAcuityAssessmentViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("VisualAcuityAssessment tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["VisualAcuityAssessmentViewController-InstructionsTableViewCell"].exists)
        XCTAssertTrue(app.cells["VisualAcuityAssessmentViewController-TooltipTableViewCell"].exists)
        XCTAssertTrue(app.cells["VisualAcuityAssessmentViewController-GroupedButtonsTableViewCell"].exists)
        XCTAssertTrue(app.cells["VisualAcuityAssessmentViewController-ImageTableViewCell"].exists)
        XCTAssertTrue(app.cells["VisualAcuityAssessmentViewController-SelectableTableViewCell-3"].exists)
        XCTAssertTrue(app.cells["VisualAcuityAssessmentViewController-ActionButtonTableViewCell"].exists)

        XCTAssertTrue(app.buttons["GroupedButtonView-print_key"].exists)
        XCTAssertTrue(app.buttons["GroupedButtonView-save_pdf_key"].exists)

        app.tables["VisualAcuityAssessmentViewController-tableView"].swipeUp(velocity: .fast)
        app.tables["VisualAcuityAssessmentViewController-tableView"].swipeUp(velocity: .fast)

        app.cells["VisualAcuityAssessmentViewController-ActionButtonTableViewCell"].tap()

        guard app.tables["ResultsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Results tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].exists)
        app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].tap()
    }

    func testLifeCyclePrinting() throws {
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

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-0"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-0"].tap()

        guard app.tables["VisualAcuityAssessmentViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("VisualAcuityAssessment tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["VisualAcuityAssessmentViewController-InstructionsTableViewCell"].exists)
        XCTAssertTrue(app.cells["VisualAcuityAssessmentViewController-TooltipTableViewCell"].exists)
        XCTAssertTrue(app.cells["VisualAcuityAssessmentViewController-GroupedButtonsTableViewCell"].exists)
        XCTAssertTrue(app.cells["VisualAcuityAssessmentViewController-ImageTableViewCell"].exists)
        XCTAssertTrue(app.cells["VisualAcuityAssessmentViewController-SelectableTableViewCell-3"].exists)
        XCTAssertTrue(app.cells["VisualAcuityAssessmentViewController-ActionButtonTableViewCell"].exists)

        XCTAssertTrue(app.buttons["GroupedButtonView-print_key"].exists)
        XCTAssertTrue(app.buttons["GroupedButtonView-save_pdf_key"].exists)

        app.tables["VisualAcuityAssessmentViewController-tableView"].swipeUp(velocity: .slow)
        app.buttons["GroupedButtonView-print_key"].tap()
    }

    func testLifeCycleSavingPDF() throws {
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

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-0"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-0"].tap()

        guard app.tables["VisualAcuityAssessmentViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("VisualAcuityAssessment tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["VisualAcuityAssessmentViewController-InstructionsTableViewCell"].exists)
        XCTAssertTrue(app.cells["VisualAcuityAssessmentViewController-TooltipTableViewCell"].exists)
        XCTAssertTrue(app.cells["VisualAcuityAssessmentViewController-GroupedButtonsTableViewCell"].exists)
        XCTAssertTrue(app.cells["VisualAcuityAssessmentViewController-ImageTableViewCell"].exists)
        XCTAssertTrue(app.cells["VisualAcuityAssessmentViewController-SelectableTableViewCell-3"].exists)
        XCTAssertTrue(app.cells["VisualAcuityAssessmentViewController-ActionButtonTableViewCell"].exists)

        XCTAssertTrue(app.buttons["GroupedButtonView-print_key"].exists)
        XCTAssertTrue(app.buttons["GroupedButtonView-save_pdf_key"].exists)

        app.tables["VisualAcuityAssessmentViewController-tableView"].swipeUp(velocity: .slow)
        app.buttons["GroupedButtonView-save_pdf_key"].tap()
    }

}
