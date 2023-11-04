//
//  MiniNutritionalAssessmentWorkerTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 03/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class MiniNutritionalAssessmentWorkerTests: XCTestCase {

    // MARK: - Private Properties

    private var currentExpectation: XCTestExpectation?
    private var dao: CoreDataDAOMock?

    // MARK: - Life Cycle

    override func setUp() {
        super.setUp()
        dao = CoreDataDAOMock()
        try? dao?.addStandaloneCGA()
    }

    override func tearDown() {
        super.tearDown()
        currentExpectation = nil
        dao = nil
    }

    // MARK: - Test Methods

    func testGetAssessmentProgress() {
        let newExpectation = expectation(description: "Call getAssessmentProgress")
        currentExpectation = newExpectation

        guard let cgaId = UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        let worker = MiniNutritionalAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            let test = try worker.getMiniNutritionalAssessmentProgress()

            guard let questionOptions = test?.selectableOptions?.allObjects as? [SelectableOption] else {
                XCTFail("Unable to get selectable options for test")
                return
            }

            var rawQuestions: MiniNutritionalAssessmentModels.RawQuestions = [:]

            questionOptions.forEach { option in
                guard let selectedOption = SelectableKeys(rawValue: option.selectedOption),
                      let identifier = LocalizedTable(rawValue: option.identifier ?? "") else { return }
                rawQuestions[identifier] = selectedOption
            }

            XCTAssertEqual(rawQuestions, [
                .miniNutritionalAssessmentFirstQuestion: .thirdOption, .miniNutritionalAssessmentSecondQuestion: .fourthOption,
                .miniNutritionalAssessmentThirdQuestion: .thirdOption, .miniNutritionalAssessmentFourthQuestion: .firstOption,
                .miniNutritionalAssessmentFifthQuestion: .thirdOption, .miniNutritionalAssessmentSeventhQuestion: .none
            ])
            XCTAssertEqual(test?.height, 174)
            XCTAssertEqual(test?.weight, 80.5)
            XCTAssertEqual(test?.isExtraQuestionSelected, false)
            XCTAssertEqual(test?.isDone, true)
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [newExpectation], timeout: 1)
    }

    func testSaveAssessmentProgress() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = expectation(description: "Call saveAssessmentProgress")
        currentExpectation = newExpectation

        guard let cgaId = UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        let worker = MiniNutritionalAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            try worker.updateMiniNutritionalAssessmentProgress(with: .init(questions: [
                .miniNutritionalAssessmentFirstQuestion: .thirdOption, .miniNutritionalAssessmentSecondQuestion: .fourthOption,
                .miniNutritionalAssessmentThirdQuestion: .secondOption, .miniNutritionalAssessmentFourthQuestion: .firstOption,
                .miniNutritionalAssessmentFifthQuestion: .firstOption, .miniNutritionalAssessmentSeventhQuestion: .secondOption
            ], height: 127, weight: 120, isExtraQuestionSelected: true, isDone: false))
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }
}
