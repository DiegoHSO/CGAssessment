//
//  MiniMentalStateExamUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 05/11/23.
//

import XCTest

final class MiniMentalStateExamUITests: XCTestCase {

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

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-0"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-0"].tap()

        guard app.tables["MiniMentalStateExamViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("MiniMentalStateExam tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["MiniMentalStateExamViewController-TitleTableViewCell"].exists)
        XCTAssertTrue(app.cells["MiniMentalStateExamViewController-ImageTableViewCell"].exists)
        XCTAssertTrue(app.cells["MiniMentalStateExamViewController-SelectableTableViewCell-0-0"].exists)
        XCTAssertTrue(app.cells["MiniMentalStateExamViewController-BinaryOptionsTableViewCell-1-0"].exists)
        XCTAssertTrue(app.cells["MiniMentalStateExamViewController-ActionButtonTableViewCell"].exists)

        app.tables["MiniMentalStateExamViewController-tableView"].swipeUp(velocity: .fast)
        app.tables["MiniMentalStateExamViewController-tableView"].swipeUp(velocity: .fast)
        app.tables["MiniMentalStateExamViewController-tableView"].swipeUp(velocity: .fast)
        app.tables["MiniMentalStateExamViewController-tableView"].swipeUp(velocity: .fast)
        app.tables["MiniMentalStateExamViewController-tableView"].swipeUp(velocity: .fast)

        XCTAssertTrue(app.cells["MiniMentalStateExamViewController-ActionButtonTableViewCell"].isHittable)
        app.cells["MiniMentalStateExamViewController-ActionButtonTableViewCell"].tap()

        guard app.tables["ResultsViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("Results tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].exists)
        app.cells["ResultsViewController-ActionButtonTableViewCell-nextTest"].tap()
    }

}
