//
//  SingleDomainInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 31/10/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class SingleDomainInteractorTests: XCTestCase {

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

    func testControllerDidLoadWithMobilityDomain() {
        let newExpectation = expectation(description: "Call controllerDidLoad with Mobility domain")
        currentExpectation = newExpectation

        let worker = SingleDomainWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = SingleDomainInteractor(presenter: self, domain: .mobility, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadWithCognitiveDomain() {
        let newExpectation = expectation(description: "Call controllerDidLoad with Cognitive domain")
        currentExpectation = newExpectation

        let worker = SingleDomainWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = SingleDomainInteractor(presenter: self, domain: .cognitive, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadWithSensoryDomain() {
        let newExpectation = expectation(description: "Call controllerDidLoad with Sensory domain")
        currentExpectation = newExpectation

        let worker = SingleDomainWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = SingleDomainInteractor(presenter: self, domain: .sensory, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadWithFunctionalDomain() {
        let newExpectation = expectation(description: "Call controllerDidLoad with Functional domain")
        currentExpectation = newExpectation

        let worker = SingleDomainWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = SingleDomainInteractor(presenter: self, domain: .functional, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadWithNutritionalDomain() {
        let newExpectation = expectation(description: "Call controllerDidLoad with Nutritional domain")
        currentExpectation = newExpectation

        let worker = SingleDomainWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = SingleDomainInteractor(presenter: self, domain: .nutritional, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadWithSocialDomain() {
        let newExpectation = expectation(description: "Call controllerDidLoad with Social domain")
        currentExpectation = newExpectation

        let worker = SingleDomainWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = SingleDomainInteractor(presenter: self, domain: .social, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadWithPolypharmacyDomain() {
        let newExpectation = expectation(description: "Call controllerDidLoad with Polypharmacy domain")
        currentExpectation = newExpectation

        let worker = SingleDomainWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = SingleDomainInteractor(presenter: self, domain: .polypharmacy, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadWithComorbidityDomain() {
        let newExpectation = expectation(description: "Call controllerDidLoad with Comorbidity domain")
        currentExpectation = newExpectation

        let worker = SingleDomainWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = SingleDomainInteractor(presenter: self, domain: .comorbidity, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadWithOtherDomain() {
        let newExpectation = expectation(description: "Call controllerDidLoad with Other domain")
        currentExpectation = newExpectation

        let worker = SingleDomainWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = SingleDomainInteractor(presenter: self, domain: .other, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadWithMobilityDomainNoCGA() {
        let newExpectation = expectation(description: "Call controllerDidLoad with Mobility domain no CGA")
        currentExpectation = newExpectation

        let newCGAWorker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)
        let patientId = try? newCGAWorker.savePatient(patientData: .init(patientName: "Test Patient", birthDate: Date().addingYear(-99), gender: .female))

        let cgaDomainsWorker = CGADomainsWorker(dao: dao ?? DAOFactory.coreDataDAO)
        let newCGAId = try? cgaDomainsWorker.saveCGA(for: patientId ?? UUID())

        let worker = SingleDomainWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = SingleDomainInteractor(presenter: self, domain: .mobility, worker: worker, cgaId: newCGAId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadWithCognitiveDomainNoCGA() {
        let newExpectation = expectation(description: "Call controllerDidLoad with Cognitive domain no CGA")
        currentExpectation = newExpectation

        let newCGAWorker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)
        let patientId = try? newCGAWorker.savePatient(patientData: .init(patientName: "Test Patient", birthDate: Date().addingYear(-99), gender: .female))

        let cgaDomainsWorker = CGADomainsWorker(dao: dao ?? DAOFactory.coreDataDAO)
        let newCGAId = try? cgaDomainsWorker.saveCGA(for: patientId ?? UUID())

        let worker = SingleDomainWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = SingleDomainInteractor(presenter: self, domain: .cognitive, worker: worker, cgaId: newCGAId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadWithSensoryDomainNoCGA() {
        let newExpectation = expectation(description: "Call controllerDidLoad with Sensory domain no CGA")
        currentExpectation = newExpectation

        let newCGAWorker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)
        let patientId = try? newCGAWorker.savePatient(patientData: .init(patientName: "Test Patient", birthDate: Date().addingYear(-99), gender: .female))

        let cgaDomainsWorker = CGADomainsWorker(dao: dao ?? DAOFactory.coreDataDAO)
        let newCGAId = try? cgaDomainsWorker.saveCGA(for: patientId ?? UUID())

        let worker = SingleDomainWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = SingleDomainInteractor(presenter: self, domain: .sensory, worker: worker, cgaId: newCGAId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadWithFunctionalDomainNoCGA() {
        let newExpectation = expectation(description: "Call controllerDidLoad with Functional domain no CGA")
        currentExpectation = newExpectation

        let newCGAWorker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)
        let patientId = try? newCGAWorker.savePatient(patientData: .init(patientName: "Test Patient", birthDate: Date().addingYear(-99), gender: .female))

        let cgaDomainsWorker = CGADomainsWorker(dao: dao ?? DAOFactory.coreDataDAO)
        let newCGAId = try? cgaDomainsWorker.saveCGA(for: patientId ?? UUID())

        let worker = SingleDomainWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = SingleDomainInteractor(presenter: self, domain: .functional, worker: worker, cgaId: newCGAId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadWithNutritionalDomainNoCGA() {
        let newExpectation = expectation(description: "Call controllerDidLoad with Nutritional domain no CGA")
        currentExpectation = newExpectation

        let newCGAWorker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)
        let patientId = try? newCGAWorker.savePatient(patientData: .init(patientName: "Test Patient", birthDate: Date().addingYear(-99), gender: .female))

        let cgaDomainsWorker = CGADomainsWorker(dao: dao ?? DAOFactory.coreDataDAO)
        let newCGAId = try? cgaDomainsWorker.saveCGA(for: patientId ?? UUID())

        let worker = SingleDomainWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = SingleDomainInteractor(presenter: self, domain: .nutritional, worker: worker, cgaId: newCGAId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadWithSocialDomainNoCGA() {
        let newExpectation = expectation(description: "Call controllerDidLoad with Social domain no CGA")
        currentExpectation = newExpectation

        let newCGAWorker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)
        let patientId = try? newCGAWorker.savePatient(patientData: .init(patientName: "Test Patient", birthDate: Date().addingYear(-99), gender: .female))

        let cgaDomainsWorker = CGADomainsWorker(dao: dao ?? DAOFactory.coreDataDAO)
        let newCGAId = try? cgaDomainsWorker.saveCGA(for: patientId ?? UUID())

        let worker = SingleDomainWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = SingleDomainInteractor(presenter: self, domain: .social, worker: worker, cgaId: newCGAId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadWithPolypharmacyDomainNoCGA() {
        let newExpectation = expectation(description: "Call controllerDidLoad with Polypharmacy domain no CGA")
        currentExpectation = newExpectation

        let newCGAWorker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)
        let patientId = try? newCGAWorker.savePatient(patientData: .init(patientName: "Test Patient", birthDate: Date().addingYear(-99), gender: .female))

        let cgaDomainsWorker = CGADomainsWorker(dao: dao ?? DAOFactory.coreDataDAO)
        let newCGAId = try? cgaDomainsWorker.saveCGA(for: patientId ?? UUID())

        let worker = SingleDomainWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = SingleDomainInteractor(presenter: self, domain: .polypharmacy, worker: worker, cgaId: newCGAId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadWithComorbidityDomainNoCGA() {
        let newExpectation = expectation(description: "Call controllerDidLoad with Comorbidity domain no CGA")
        currentExpectation = newExpectation

        let newCGAWorker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)
        let patientId = try? newCGAWorker.savePatient(patientData: .init(patientName: "Test Patient", birthDate: Date().addingYear(-99), gender: .female))

        let cgaDomainsWorker = CGADomainsWorker(dao: dao ?? DAOFactory.coreDataDAO)
        let newCGAId = try? cgaDomainsWorker.saveCGA(for: patientId ?? UUID())

        let worker = SingleDomainWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = SingleDomainInteractor(presenter: self, domain: .comorbidity, worker: worker, cgaId: newCGAId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadWithOtherDomainNoCGA() {
        let newExpectation = expectation(description: "Call controllerDidLoad with Other domain no CGA")
        currentExpectation = newExpectation

        let newCGAWorker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)
        let patientId = try? newCGAWorker.savePatient(patientData: .init(patientName: "Test Patient", birthDate: Date().addingYear(-99), gender: .female))

        let cgaDomainsWorker = CGADomainsWorker(dao: dao ?? DAOFactory.coreDataDAO)
        let newCGAId = try? cgaDomainsWorker.saveCGA(for: patientId ?? UUID())

        let worker = SingleDomainWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = SingleDomainInteractor(presenter: self, domain: .other, worker: worker, cgaId: newCGAId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectTest() {
        let newExpectation = expectation(description: "Call didSelect test")
        currentExpectation = newExpectation

        let worker = SingleDomainWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = SingleDomainInteractor(presenter: self, domain: .other, worker: worker, cgaId: nil)
        interactor.didSelect(test: .chemotherapyToxicityRisk)

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - SingleDomainPresentationLogic extension

extension SingleDomainInteractorTests: SingleDomainPresentationLogic {
    func route(toRoute route: SingleDomainModels.Routing) {
        switch currentExpectation?.description {
        case "Call didSelect test":
            XCTAssertEqual(route, .domainTest(test: .chemotherapyToxicityRisk, cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: SingleDomainModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad with Mobility domain":
            XCTAssertEqual(viewModel.domain, .mobility)
            XCTAssertEqual(viewModel.tests.map { $0.test }, [.timedUpAndGo, .walkingSpeed, .calfCircumference,
                                                             .gripStrength, .sarcopeniaScreening])
            XCTAssertTrue(viewModel.tests.allSatisfy { $0.status == .done })
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Mock CGA")
        case "Call controllerDidLoad with Cognitive domain":
            XCTAssertEqual(viewModel.domain, .cognitive)
            XCTAssertEqual(viewModel.tests.map { $0.test }, [.miniMentalStateExamination, .verbalFluencyTest,
                                                             .clockDrawingTest, .moca, .geriatricDepressionScale])
            XCTAssertTrue(viewModel.tests.allSatisfy { $0.status == .done })
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Mock CGA")
        case "Call controllerDidLoad with Sensory domain":
            XCTAssertEqual(viewModel.domain, .sensory)
            XCTAssertEqual(viewModel.tests.map { $0.test }, [.visualAcuityAssessment, .hearingLossAssessment])
            XCTAssertTrue(viewModel.tests.allSatisfy { $0.status == .done })
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Mock CGA")
        case "Call controllerDidLoad with Functional domain":
            XCTAssertEqual(viewModel.domain, .functional)
            XCTAssertEqual(viewModel.tests.map { $0.test }, [.katzScale, .lawtonScale])
            XCTAssertTrue(viewModel.tests.allSatisfy { $0.status == .done })
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Mock CGA")
        case "Call controllerDidLoad with Nutritional domain":
            XCTAssertEqual(viewModel.domain, .nutritional)
            XCTAssertEqual(viewModel.tests.map { $0.test }, [.miniNutritionalAssessment])
            XCTAssertTrue(viewModel.tests.allSatisfy { $0.status == .done })
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Mock CGA")
        case "Call controllerDidLoad with Social domain":
            XCTAssertEqual(viewModel.domain, .social)
            XCTAssertEqual(viewModel.tests.map { $0.test }, [.apgarScale, .zaritScale])
            XCTAssertTrue(viewModel.tests.allSatisfy { $0.status == .done })
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Mock CGA")
        case "Call controllerDidLoad with Polypharmacy domain":
            XCTAssertEqual(viewModel.domain, .polypharmacy)
            XCTAssertEqual(viewModel.tests.map { $0.test }, [.polypharmacyCriteria])
            XCTAssertTrue(viewModel.tests.allSatisfy { $0.status == .done })
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Mock CGA")
        case "Call controllerDidLoad with Comorbidity domain":
            XCTAssertEqual(viewModel.domain, .comorbidity)
            XCTAssertEqual(viewModel.tests.map { $0.test }, [.charlsonIndex])
            XCTAssertTrue(viewModel.tests.allSatisfy { $0.status == .done })
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Mock CGA")
        case "Call controllerDidLoad with Other domain":
            XCTAssertEqual(viewModel.domain, .other)
            XCTAssertEqual(viewModel.tests.map { $0.test }, [.suspectedAbuse, .chemotherapyToxicityRisk])
            XCTAssertTrue(viewModel.tests.allSatisfy { $0.status == .done })
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Mock CGA")
        case "Call controllerDidLoad with Mobility domain no CGA":
            XCTAssertEqual(viewModel.domain, .mobility)
            XCTAssertEqual(viewModel.tests.map { $0.test }, [.timedUpAndGo, .walkingSpeed, .calfCircumference,
                                                             .gripStrength, .sarcopeniaScreening])
            XCTAssertTrue(viewModel.tests.allSatisfy { $0.status == .notStarted })
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Test Patient")
        case "Call controllerDidLoad with Cognitive domain no CGA":
            XCTAssertEqual(viewModel.domain, .cognitive)
            XCTAssertEqual(viewModel.tests.map { $0.test }, [.miniMentalStateExamination, .verbalFluencyTest,
                                                             .clockDrawingTest, .moca, .geriatricDepressionScale])
            XCTAssertTrue(viewModel.tests.allSatisfy { $0.status == .notStarted })
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Test Patient")
        case "Call controllerDidLoad with Sensory domain no CGA":
            XCTAssertEqual(viewModel.domain, .sensory)
            XCTAssertEqual(viewModel.tests.map { $0.test }, [.visualAcuityAssessment, .hearingLossAssessment])
            XCTAssertTrue(viewModel.tests.allSatisfy { $0.status == .notStarted })
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Test Patient")
        case "Call controllerDidLoad with Functional domain no CGA":
            XCTAssertEqual(viewModel.domain, .functional)
            XCTAssertEqual(viewModel.tests.map { $0.test }, [.katzScale, .lawtonScale])
            XCTAssertTrue(viewModel.tests.allSatisfy { $0.status == .notStarted })
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Test Patient")
        case "Call controllerDidLoad with Nutritional domain no CGA":
            XCTAssertEqual(viewModel.domain, .nutritional)
            XCTAssertEqual(viewModel.tests.map { $0.test }, [.miniNutritionalAssessment])
            XCTAssertTrue(viewModel.tests.allSatisfy { $0.status == .notStarted })
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Test Patient")
        case "Call controllerDidLoad with Social domain no CGA":
            XCTAssertEqual(viewModel.domain, .social)
            XCTAssertEqual(viewModel.tests.map { $0.test }, [.apgarScale, .zaritScale])
            XCTAssertTrue(viewModel.tests.allSatisfy { $0.status == .notStarted })
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Test Patient")
        case "Call controllerDidLoad with Polypharmacy domain no CGA":
            XCTAssertEqual(viewModel.domain, .polypharmacy)
            XCTAssertEqual(viewModel.tests.map { $0.test }, [.polypharmacyCriteria])
            XCTAssertTrue(viewModel.tests.allSatisfy { $0.status == .notStarted })
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Test Patient")
        case "Call controllerDidLoad with Comorbidity domain no CGA":
            XCTAssertEqual(viewModel.domain, .comorbidity)
            XCTAssertEqual(viewModel.tests.map { $0.test }, [.charlsonIndex])
            XCTAssertTrue(viewModel.tests.allSatisfy { $0.status == .notStarted })
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Test Patient")
        case "Call controllerDidLoad with Other domain no CGA":
            XCTAssertEqual(viewModel.domain, .other)
            XCTAssertEqual(viewModel.tests.map { $0.test }, [.suspectedAbuse, .chemotherapyToxicityRisk])
            XCTAssertTrue(viewModel.tests.allSatisfy { $0.status == .notStarted })
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Test Patient")
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }
}
