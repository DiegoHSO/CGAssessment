//
//  ResultsInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 31/10/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class ResultsInteractorTests: XCTestCase {

    // MARK: - Private Properties

    private var currentExpectation: XCTestExpectation?
    private var dao: CoreDataDAOMock?
    private let cgaId = UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3")

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

    func testControllerDidLoad() {
        let newExpectation = expectation(description: "Call controllerDidLoad")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .polypharmacyCriteria,
                                           results: PolypharmacyCriteriaModels.TestResults(numberOfMedicines: 20),
                                           isInSpecialFlow: false)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadWithInvalidTestResults() {
        let newExpectation = expectation(description: "Call controllerDidLoad with invalid test results")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .polypharmacyCriteria,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToGoToWalkingSpeedTest() {
        let newExpectation = expectation(description: "Call didTapToGoTo walking speed")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .timedUpAndGo,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: LocalizedTable.nextTest.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToGoToCalfCircumferenceTest() {
        let newExpectation = expectation(description: "Call didTapToGoTo calf circumference")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .walkingSpeed,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: LocalizedTable.nextTest.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToGoToGripStrengthTest() {
        let newExpectation = expectation(description: "Call didTapToGoTo grip strength")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .calfCircumference,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: LocalizedTable.nextTest.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToGoToSarcopeniaScreeningTest() {
        let newExpectation = expectation(description: "Call didTapToGoTo sarcopenia screening")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .gripStrength,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: LocalizedTable.nextTest.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToGoToSarcopeniaAsssessmentTest() {
        let newExpectation = expectation(description: "Call didTapToGoTo sarcopenia assessment")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .sarcopeniaScreening,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: LocalizedTable.secondStep.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToGoToMiniMentalStateExamTest() {
        let newExpectation = expectation(description: "Call didTapToGoTo mini mental state exam")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .sarcopeniaAssessment,
                                           results: (Any).self, isInSpecialFlow: true)
        interactor.didTapActionButton(identifier: LocalizedTable.nextTest.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToGoToVerbalFluencyTest() {
        let newExpectation = expectation(description: "Call didTapToGoTo verbal fluency")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .miniMentalStateExamination,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: LocalizedTable.nextTest.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToGoToClockDrawingTest() {
        let newExpectation = expectation(description: "Call didTapToGoTo clock drawing")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .verbalFluencyTest,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: LocalizedTable.nextTest.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToGoToMoCATest() {
        let newExpectation = expectation(description: "Call didTapToGoTo MoCA")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .clockDrawingTest,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: LocalizedTable.nextTest.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToGoToGeriatricDepressionScaleTest() {
        let newExpectation = expectation(description: "Call didTapToGoTo geriatric depression scale")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .moca,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: LocalizedTable.nextTest.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToGoToVisualAcuityTest() {
        let newExpectation = expectation(description: "Call didTapToGoTo visual acuity")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .geriatricDepressionScale,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: LocalizedTable.nextTest.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToGoToHearingLossTest() {
        let newExpectation = expectation(description: "Call didTapToGoTo hearing loss")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .visualAcuityAssessment,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: LocalizedTable.nextTest.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToGoToKatzScaleTest() {
        let newExpectation = expectation(description: "Call didTapToGoTo katz scale")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .hearingLossAssessment,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: LocalizedTable.nextTest.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToGoToLawtonScaleTest() {
        let newExpectation = expectation(description: "Call didTapToGoTo lawton scale")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .katzScale,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: LocalizedTable.nextTest.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToGoToMiniNutritionalAssessmentTest() {
        let newExpectation = expectation(description: "Call didTapToGoTo mini nutritional assessment")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .lawtonScale,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: LocalizedTable.nextTest.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToGoToApgarScaleTest() {
        let newExpectation = expectation(description: "Call didTapToGoTo apgar scale")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .miniNutritionalAssessment,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: LocalizedTable.nextTest.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToGoToZaritScaleTest() {
        let newExpectation = expectation(description: "Call didTapToGoTo zarit scale")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .apgarScale,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: LocalizedTable.nextTest.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToGoToPolypharmacyCriteriaTest() {
        let newExpectation = expectation(description: "Call didTapToGoTo polypharmacy criteria")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .zaritScale,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: LocalizedTable.nextTest.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToGoToCharlsonIndexTest() {
        let newExpectation = expectation(description: "Call didTapToGoTo charlson index")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .polypharmacyCriteria,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: LocalizedTable.nextTest.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToGoToSuspectedAbuseTest() {
        let newExpectation = expectation(description: "Call didTapToGoTo suspected abuse")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .charlsonIndex,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: LocalizedTable.nextTest.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToGoToChemotherapyToxicityRiskTest() {
        let newExpectation = expectation(description: "Call didTapToGoTo chemotherapy toxicity risk")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .suspectedAbuse,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: LocalizedTable.nextTest.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToReturn() {
        let newExpectation = expectation(description: "Call didTapTo return")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .timedUpAndGo,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: LocalizedTable.returnKey.localized)

        wait(for: [newExpectation], timeout: 1)
    }

    func testUpdateSarcopeniaAssessmentProgressWithIsDone() {
        let newExpectation = expectation(description: "Call updateSarcopeniaAssessmentProgressWith isDone")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3"))

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .sarcopeniaScreening,
                                           results: SarcopeniaScreeningModels.TestResults(questions: [.sarcopeniaAssessmentFirstQuestion: .firstOption, .sarcopeniaAssessmentSecondQuestion: .firstOption,
                                                                                                      .sarcopeniaAssessmentThirdQuestion: .firstOption, .sarcopeniaAssessmentFourthQuestion: .firstOption,
                                                                                                      .sarcopeniaAssessmentFifthQuestion: .firstOption, .sarcopeniaAssessmentSixthQuestion: .firstOption],
                                                                                          gender: .male), isInSpecialFlow: false)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testUpdateSarcopeniaAssessmentProgressWithIsNotDone() {
        let newExpectation = expectation(description: "Call updateSarcopeniaAssessmentProgressWith isNotDone")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3"))

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .sarcopeniaScreening,
                                           results: SarcopeniaScreeningModels.TestResults(questions: [.sarcopeniaAssessmentFirstQuestion: .firstOption, .sarcopeniaAssessmentSecondQuestion: .secondOption,
                                                                                                      .sarcopeniaAssessmentThirdQuestion: .secondOption, .sarcopeniaAssessmentFourthQuestion: .firstOption,
                                                                                                      .sarcopeniaAssessmentFifthQuestion: .secondOption, .sarcopeniaAssessmentSixthQuestion: .secondOption],
                                                                                          gender: .male), isInSpecialFlow: false)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapActionButtonWithInvalidIdentifier() {
        let newExpectation = expectation(description: "Call didTap action button with invalid identifier")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = ResultsInteractor(presenter: self, worker: worker, test: .suspectedAbuse,
                                           results: (Any).self, isInSpecialFlow: false)
        interactor.didTapActionButton(identifier: nil)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - ResultsPresentationLogic extension

extension ResultsInteractorTests: ResultsPresentationLogic {
    func route(toRoute route: ResultsModels.Routing) {
        switch currentExpectation?.description {
        case "Call didTapToGoTo walking speed":
            XCTAssertEqual(route, .nextTest(test: .walkingSpeed))
        case "Call didTapToGoTo calf circumference":
            XCTAssertEqual(route, .nextTest(test: .calfCircumference))
        case "Call didTapToGoTo grip strength":
            XCTAssertEqual(route, .nextTest(test: .gripStrength))
        case "Call didTapToGoTo sarcopenia screening":
            XCTAssertEqual(route, .nextTest(test: .sarcopeniaScreening))
        case "Call didTapToGoTo sarcopenia assessment":
            XCTAssertEqual(route, .sarcopeniaAssessment)
        case "Call didTapToGoTo mini mental state exam":
            XCTAssertEqual(route, .nextTest(test: .miniMentalStateExamination))
        case "Call didTapToGoTo verbal fluency":
            XCTAssertEqual(route, .nextTest(test: .verbalFluencyTest))
        case "Call didTapToGoTo clock drawing":
            XCTAssertEqual(route, .nextTest(test: .clockDrawingTest))
        case "Call didTapToGoTo MoCA":
            XCTAssertEqual(route, .nextTest(test: .moca))
        case "Call didTapToGoTo geriatric depression scale":
            XCTAssertEqual(route, .nextTest(test: .geriatricDepressionScale))
        case "Call didTapToGoTo visual acuity":
            XCTAssertEqual(route, .nextTest(test: .visualAcuityAssessment))
        case "Call didTapToGoTo hearing loss":
            XCTAssertEqual(route, .nextTest(test: .hearingLossAssessment))
        case "Call didTapToGoTo katz scale":
            XCTAssertEqual(route, .nextTest(test: .katzScale))
        case "Call didTapToGoTo lawton scale":
            XCTAssertEqual(route, .nextTest(test: .lawtonScale))
        case "Call didTapToGoTo mini nutritional assessment":
            XCTAssertEqual(route, .nextTest(test: .miniNutritionalAssessment))
        case "Call didTapToGoTo apgar scale":
            XCTAssertEqual(route, .nextTest(test: .apgarScale))
        case "Call didTapToGoTo zarit scale":
            XCTAssertEqual(route, .nextTest(test: .zaritScale))
        case "Call didTapToGoTo polypharmacy criteria":
            XCTAssertEqual(route, .nextTest(test: .polypharmacyCriteria))
        case "Call didTapToGoTo charlson index":
            XCTAssertEqual(route, .nextTest(test: .charlsonIndex))
        case "Call didTapToGoTo suspected abuse":
            XCTAssertEqual(route, .nextTest(test: .suspectedAbuse))
        case "Call didTapToGoTo chemotherapy toxicity risk":
            XCTAssertEqual(route, .nextTest(test: .chemotherapyToxicityRisk))
        case "Call didTapTo return":
            XCTAssertEqual(route, .routeBack(domain: .mobility))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: ResultsModels.ViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad":
            XCTAssertEqual(viewModel.testName, LocalizedTable.polypharmacyCriteria.localized)
            XCTAssertEqual(viewModel.resultType, .bad)
            XCTAssertFalse(viewModel.isInSpecialFlow)
        case "Call controllerDidLoad with invalid test results":
            XCTAssertTrue(viewModel.testName.isEmpty)
            XCTAssertTrue(viewModel.results.isEmpty)
            XCTAssertFalse(viewModel.isInSpecialFlow)
        case "Call updateSarcopeniaAssessmentProgressWith isDone":
            XCTAssertEqual(viewModel.testName, LocalizedTable.sarcopeniaScreening.localized)
            XCTAssertEqual(viewModel.resultType, .excellent)
        case "Call updateSarcopeniaAssessmentProgressWith isNotDone":
            XCTAssertEqual(viewModel.testName, LocalizedTable.sarcopeniaScreening.localized)
            XCTAssertEqual(viewModel.resultType, .bad)
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }
}
