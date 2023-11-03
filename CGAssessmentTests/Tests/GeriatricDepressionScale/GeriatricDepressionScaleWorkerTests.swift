//
//  GeriatricDepressionScaleWorkerTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 03/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class GeriatricDepressionScaleWorkerTests: XCTestCase {

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

        let worker = GeriatricDepressionScaleWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            let test = try worker.getGeriatricDepressionScaleProgress()

            guard let questionOptions = test?.selectableOptions?.allObjects as? [SelectableOption] else {
                XCTFail("Unable to get selectable options for test")
                return
            }

            var rawQuestions: GeriatricDepressionScaleModels.RawQuestions = [:]

            questionOptions.forEach { option in
                guard let selectedOption = SelectableKeys(rawValue: option.selectedOption),
                      let identifier = LocalizedTable(rawValue: option.identifier ?? "") else { return }
                rawQuestions[identifier] = selectedOption
            }

            XCTAssertEqual(rawQuestions, [.geriatricDepressionScaleQuestionOne: .firstOption, .geriatricDepressionScaleQuestionTwo: .firstOption, .geriatricDepressionScaleQuestionThree: .firstOption,
                                          .geriatricDepressionScaleQuestionFour: .firstOption, .geriatricDepressionScaleQuestionFive: .secondOption,
                                          .geriatricDepressionScaleQuestionSix: .secondOption, .geriatricDepressionScaleQuestionSeven: .secondOption,
                                          .geriatricDepressionScaleQuestionEight: .secondOption, .geriatricDepressionScaleQuestionNine: .secondOption,
                                          .geriatricDepressionScaleQuestionTen: .secondOption, .geriatricDepressionScaleQuestionEleven: .firstOption,
                                          .geriatricDepressionScaleQuestionTwelve: .firstOption, .geriatricDepressionScaleQuestionThirteen: .firstOption,
                                          .geriatricDepressionScaleQuestionFourteen: .firstOption, .geriatricDepressionScaleQuestionFifteen: .secondOption
            ])
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

        let worker = GeriatricDepressionScaleWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            try worker.updateGeriatricDepressionScaleProgress(with: .init(questions: [.geriatricDepressionScaleQuestionOne: .firstOption, .geriatricDepressionScaleQuestionTwo: .secondOption, .geriatricDepressionScaleQuestionThree: .secondOption,
                                                                                      .geriatricDepressionScaleQuestionFour: .secondOption, .geriatricDepressionScaleQuestionFive: .secondOption,
                                                                                      .geriatricDepressionScaleQuestionSix: .secondOption, .geriatricDepressionScaleQuestionSeven: .secondOption,
                                                                                      .geriatricDepressionScaleQuestionEight: .secondOption, .geriatricDepressionScaleQuestionNine: .firstOption,
                                                                                      .geriatricDepressionScaleQuestionTen: .firstOption, .geriatricDepressionScaleQuestionEleven: .firstOption,
                                                                                      .geriatricDepressionScaleQuestionTwelve: .firstOption, .geriatricDepressionScaleQuestionThirteen: .firstOption,
                                                                                      .geriatricDepressionScaleQuestionFourteen: .firstOption, .geriatricDepressionScaleQuestionFifteen: .firstOption
            ], isDone: false))
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }
}
