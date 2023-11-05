//
//  MoCAUITests.swift
//  CGAssessmentUITests
//
//  Created by Diego Henrique Silva Oliveira on 05/11/23.
//

import XCTest

final class MoCAUITests: XCTestCase {

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

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-3"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-3"].tap()

        guard app.tables["MoCAViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("MoCA tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["MoCAViewController-TitleTableViewCell-0-0"].exists)
        XCTAssertTrue(app.cells["MoCAViewController-ImageTableViewCell-0-1"].exists)
        XCTAssertTrue(app.cells["MoCAViewController-SelectableTableViewCell-8-0"].exists)
        XCTAssertTrue(app.cells["MoCAViewController-BinaryOptionsTableViewCell-0-4"].exists)
        XCTAssertTrue(app.cells["MoCAViewController-CentralizedTextTableViewCell-2-1"].exists)
        XCTAssertTrue(app.cells["MoCAViewController-GroupedButtonsTableViewCell"].exists)
        XCTAssertTrue(app.cells["MoCAViewController-StepperTableViewCell"].exists)
        XCTAssertTrue(app.cells["MoCAViewController-ActionButtonTableViewCell"].exists)

        app.tables["MoCAViewController-tableView"].swipeUp(velocity: .fast)

        XCTAssertTrue(app.buttons["GroupedButtonView-gallery_key"].exists)
        XCTAssertTrue(app.buttons["GroupedButtonView-take_photo_key"].exists)

        app.tables["MoCAViewController-tableView"].swipeUp(velocity: .fast)
        app.tables["MoCAViewController-tableView"].swipeUp(velocity: .fast)
        app.tables["MoCAViewController-tableView"].swipeUp(velocity: .fast)
        app.tables["MoCAViewController-tableView"].swipeUp(velocity: .fast)

        app.buttons["Increment"].firstMatch.tap()
        app.buttons["Decrement"].firstMatch.tap()

        app.tables["MoCAViewController-tableView"].swipeUp(velocity: .fast)
        app.tables["MoCAViewController-tableView"].swipeUp(velocity: .fast)
        app.tables["MoCAViewController-tableView"].swipeUp(velocity: .fast)

        XCTAssertTrue(app.cells["MoCAViewController-ActionButtonTableViewCell"].isHittable)
        app.cells["MoCAViewController-ActionButtonTableViewCell"].tap()
    }

    func testLifeCycleOpeningGallery() throws {
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

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-3"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-3"].tap()

        guard app.tables["MoCAViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("MoCA tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["MoCAViewController-TitleTableViewCell-0-0"].exists)
        XCTAssertTrue(app.cells["MoCAViewController-ImageTableViewCell-0-1"].exists)
        XCTAssertTrue(app.cells["MoCAViewController-SelectableTableViewCell-8-0"].exists)
        XCTAssertTrue(app.cells["MoCAViewController-BinaryOptionsTableViewCell-0-4"].exists)
        XCTAssertTrue(app.cells["MoCAViewController-CentralizedTextTableViewCell-2-1"].exists)
        XCTAssertTrue(app.cells["MoCAViewController-GroupedButtonsTableViewCell"].exists)
        XCTAssertTrue(app.cells["MoCAViewController-StepperTableViewCell"].exists)
        XCTAssertTrue(app.cells["MoCAViewController-ActionButtonTableViewCell"].exists)

        app.tables["MoCAViewController-tableView"].swipeUp(velocity: .fast)

        XCTAssertTrue(app.buttons["GroupedButtonView-gallery_key"].exists)
        XCTAssertTrue(app.buttons["GroupedButtonView-take_photo_key"].exists)

        app.buttons["GroupedButtonView-gallery_key"].tap()
    }

    func testLifeCycleOpeningCamera() throws {
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

        XCTAssertTrue(app.cells["SingleDomainViewController-TestTableViewCell-3"].exists)

        app.cells["SingleDomainViewController-TestTableViewCell-3"].tap()

        guard app.tables["MoCAViewController-tableView"].waitForExistence(timeout: 10) else {
            XCTFail("MoCA tableView was not presented")
            return
        }

        XCTAssertTrue(app.cells["MoCAViewController-TitleTableViewCell-0-0"].exists)
        XCTAssertTrue(app.cells["MoCAViewController-ImageTableViewCell-0-1"].exists)
        XCTAssertTrue(app.cells["MoCAViewController-SelectableTableViewCell-8-0"].exists)
        XCTAssertTrue(app.cells["MoCAViewController-BinaryOptionsTableViewCell-0-4"].exists)
        XCTAssertTrue(app.cells["MoCAViewController-CentralizedTextTableViewCell-2-1"].exists)
        XCTAssertTrue(app.cells["MoCAViewController-GroupedButtonsTableViewCell"].exists)
        XCTAssertTrue(app.cells["MoCAViewController-StepperTableViewCell"].exists)
        XCTAssertTrue(app.cells["MoCAViewController-ActionButtonTableViewCell"].exists)

        app.tables["MoCAViewController-tableView"].swipeUp(velocity: .fast)

        XCTAssertTrue(app.buttons["GroupedButtonView-gallery_key"].exists)
        XCTAssertTrue(app.buttons["GroupedButtonView-take_photo_key"].exists)

        XCTAssertTrue(app.buttons["GroupedButtonView-take_photo_key"].isHittable)
    }

}
