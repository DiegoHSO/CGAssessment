//
//  SarcopeniaScreeningWorkerTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class SarcopeniaScreeningWorkerTests: XCTestCase {

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

        let worker = SarcopeniaScreeningWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            let test = try worker.getSarcopeniaScreeningProgress()

            guard let questionOptions = test?.selectableOptions?.allObjects as? [SelectableOption] else {
                XCTFail("Unable to get selectable options for test")
                return
            }

            var rawQuestions: SarcopeniaScreeningModels.RawQuestions = [:]

            questionOptions.forEach { option in
                guard let selectedOption = SelectableKeys(rawValue: option.selectedOption),
                      let identifier = LocalizedTable(rawValue: option.identifier ?? "") else { return }
                rawQuestions[identifier] = selectedOption
            }

            XCTAssertEqual(rawQuestions, [.sarcopeniaAssessmentFirstQuestion: .thirdOption, .sarcopeniaAssessmentSecondQuestion: .secondOption,
                                          .sarcopeniaAssessmentThirdQuestion: .secondOption, .sarcopeniaAssessmentFourthQuestion: .firstOption,
                                          .sarcopeniaAssessmentFifthQuestion: .secondOption, .sarcopeniaAssessmentSixthQuestion: .secondOption])
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

        let worker = SarcopeniaScreeningWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            try worker.updateSarcopeniaScreeningProgress(with: .init(questions: [.sarcopeniaAssessmentFirstQuestion: .firstOption, .sarcopeniaAssessmentSecondQuestion: .firstOption,
                                                                                 .sarcopeniaAssessmentThirdQuestion: .thirdOption, .sarcopeniaAssessmentFourthQuestion: .firstOption,
                                                                                 .sarcopeniaAssessmentFifthQuestion: .secondOption, .sarcopeniaAssessmentSixthQuestion: .secondOption], isDone: false))
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testGetPatientGender() {
        let newExpectation = expectation(description: "Call getPatientGender")
        currentExpectation = newExpectation

        guard let cgaId = UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        let worker = SarcopeniaScreeningWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            let gender = try worker.getPatientGender()
            XCTAssertEqual(gender, .female)
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetInvalidPatientGender() {
        let newExpectation = expectation(description: "Call getPatientGender invalid")
        currentExpectation = newExpectation

        guard let cgaId = UUID(uuidString: "1734772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        let worker = SarcopeniaScreeningWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            _ = try worker.getPatientGender()
        } catch {
            currentExpectation?.fulfill()
        }

        wait(for: [newExpectation], timeout: 1)
    }
}
