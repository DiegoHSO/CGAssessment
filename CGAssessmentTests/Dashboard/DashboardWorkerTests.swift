//
//  DashboardWorkerTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 29/10/23.
//

import XCTest
@testable import CGAssessment

/*
 final class DashboardWorkerTests: XCTestCase {
 // MARK: - Private Properties

 private var currentExpectation: XCTestExpectation?

 // MARK: - Life Cycle

 override func tearDown() {
 super.tearDown()
 currentExpectation = nil
 }

 // MARK: - Test Methods

 func testRequestFactoryLines() {
 let newExpectation = expectation(description: "Call requestFactoryLines")
 currentExpectation = newExpectation
 expectedMethodName = "presentFactoryCells(response:)"

 newExpectation.expectedFulfillmentCount = 3

 let worker = WholeFactoryWorker(machineStatesDAO: MachineStateDAOMock())

 let interactor = WholeFactoryInteractor(presenter: self, worker: worker,
 localStorageManager: localStorageManager)
 interactor.requestFactoryLines()

 wait(for: [newExpectation], timeout: 1)
 }

 }
 */

// MARK: - WholeFactoryPresentationLogic extension

/*
 extension DashboardWorkerTests: WholeFactoryPresentationLogic {

 func route(to route: FactoryView.WholeFactoryModels.Routing) {
 switch route {
 case .notificationsList:
 expect(self.currentExpectation?.description) == "Call didTapNotifications"
 currentExpectation?.fulfill()

 case .settings:
 expect(self.currentExpectation?.description) == "Call didTapSettings"
 currentExpectation?.fulfill()

 case .singleLine:
 expect(self.currentExpectation?.description) == "Call didSelectLine"
 currentExpectation?.fulfill()

 case .singleStation:
 expect(self.currentExpectation?.description) == "Call didSelectStation"
 currentExpectation?.fulfill()
 }
 }
 }
 */
