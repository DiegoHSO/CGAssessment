//
//  CoreDataDAO.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 29/09/23.
//

import CoreData
import UIKit

enum CoreDataErrors: Error, Equatable {
    case duplicatedPatient
    case unableToFetchCGA
    case unableToFetchPatient
    case unableToUpdateCGA
}

protocol CoreDataDAOProtocol {
    func addCGA(for patient: Patient) throws -> UUID
    func addPatient(_ patient: NewCGAModels.PatientData) throws -> UUID
    func fetchCGAs() throws -> [CGA]
    func fetchCGA(cgaId: UUID) throws -> CGA?
    func fetchPatientCGAs(patient: Patient) throws -> [CGA]
    func fetchPatients() throws -> [Patient]
    func fetchPatient(patientId: UUID) throws -> Patient?
    func fetchCGATest(test: SingleDomainModels.Test, cgaId: UUID) throws -> Any?
    func updateCGA(with test: TimedUpAndGoModels.TestData, cgaId: UUID) throws
    func updateCGA(with test: WalkingSpeedModels.TestData, cgaId: UUID) throws
    func updateCGA(with test: CalfCircumferenceModels.TestData, cgaId: UUID) throws
    func updateCGA(with test: GripStrengthModels.TestData, cgaId: UUID) throws
    func updateCGA(with test: SarcopeniaScreeningModels.TestData, cgaId: UUID) throws
}

class CoreDataDAO: CoreDataDAOProtocol {

    // MARK: - Private Properties

    private var context: NSManagedObjectContext {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext ?? .init(concurrencyType: .mainQueueConcurrencyType)
    }

    // MARK: - Public Methods

    func addCGA(for patient: Patient) throws -> UUID {
        let newCGA = CGA(context: context)
        let cgaId = UUID()

        newCGA.patient = patient
        newCGA.lastModification = Date()
        newCGA.cgaId = cgaId

        try context.save()

        return cgaId
    }

    func addPatient(_ patient: NewCGAModels.PatientData) throws -> UUID {
        let patients = try fetchPatients()
        let hasPatient = patients.contains(where: { $0.name == patient.patientName &&
                                            $0.birthDate == patient.birthDate.removingTimeComponents() &&
                                            $0.gender == patient.gender.rawValue })

        if hasPatient {
            throw CoreDataErrors.duplicatedPatient
        }

        let newPatient = Patient(context: context)
        let patientId = UUID()
        newPatient.birthDate = patient.birthDate.removingTimeComponents()
        newPatient.gender = patient.gender.rawValue
        newPatient.name = patient.patientName
        newPatient.patientId = patientId

        try context.save()

        return patientId
    }

    func fetchCGAs() throws -> [CGA] {
        return try context.fetch(CGA.fetchRequest())
    }

    func fetchCGA(cgaId: UUID) throws -> CGA? {
        let request = CGA.fetchRequest() as NSFetchRequest<CGA>
        request.fetchLimit = 1

        let cgaPredicate = NSPredicate(format: "cgaId == %@", cgaId.uuidString)

        request.predicate = cgaPredicate

        return try context.fetch(request).first
    }

    func fetchPatientCGAs(patient: Patient) throws -> [CGA] {
        let request = CGA.fetchRequest() as NSFetchRequest<CGA>

        guard let patientId = patient.patientId else { throw CoreDataErrors.unableToFetchCGA }

        let patientPredicate = NSPredicate(format: "patient.patientId == %@",
                                           patientId.uuidString)

        request.predicate = patientPredicate

        return try context.fetch(request)
    }

    func fetchPatients() throws -> [Patient] {
        return try context.fetch(Patient.fetchRequest())
    }

    func fetchPatient(patientId: UUID) throws -> Patient? {
        let request = Patient.fetchRequest() as NSFetchRequest<Patient>
        request.fetchLimit = 1

        let patientPredicate = NSPredicate(format: "patientId == %@",
                                           patientId.uuidString)

        request.predicate = patientPredicate

        return try context.fetch(request).first
    }

    func fetchCGATest(test: SingleDomainModels.Test, cgaId: UUID) throws -> Any? {
        let cga = try fetchCGA(cgaId: cgaId)

        switch test {
        case .timedUpAndGo:
            return cga?.timedUpAndGo
        case .walkingSpeed:
            return cga?.walkingSpeed
        case .calfCircumference:
            return cga?.calfCircumference
        case .gripStrength:
            return cga?.gripStrength
        case .sarcopeniaAssessment:
            return cga?.sarcopeniaScreening
        case .miniMentalStateExamination:
            return nil
        case .verbalFluencyTest:
            return nil
        case .clockDrawingTest:
            return nil
        case .moca:
            return nil
        case .geriatricDepressionScale:
            return nil
        case .visualAcuityAssessment:
            return nil
        case .hearingLossAssessment:
            return nil
        case .katzScale:
            return nil
        case .lawtonScale:
            return nil
        case .miniNutritionalAssessment:
            return nil
        case .apgarScale:
            return nil
        case .zaritScale:
            return nil
        case .polypharmacyCriteria:
            return nil
        case .charlsonIndex:
            return nil
        case .suspectedAbuse:
            return nil
        case .cardiovascularRiskEstimation:
            return nil
        case .chemotherapyToxicityRisk:
            return nil
        }
    }

    func updateCGA(with test: TimedUpAndGoModels.TestData, cgaId: UUID) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.timedUpAndGo == nil {
            try createTimedUpAndGoInstance(for: cga)
        }

        if let elapsedTime = test.elapsedTime {
            cga.timedUpAndGo?.measuredTime = NSNumber(floatLiteral: elapsedTime)
        }

        if let typedElapsedTime = test.typedElapsedTime {
            cga.timedUpAndGo?.typedTime = NSNumber(floatLiteral: typedElapsedTime)
        }

        cga.timedUpAndGo?.hasStopwatch = test.selectedOption == .firstOption
        cga.timedUpAndGo?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: WalkingSpeedModels.TestData, cgaId: UUID) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.walkingSpeed == nil {
            try createWalkingSpeedInstance(for: cga)
        }

        if let firstElapsedTime = test.firstElapsedTime {
            cga.walkingSpeed?.firstMeasuredTime = firstElapsedTime
        }

        if let secondElapsedTime = test.secondElapsedTime {
            cga.walkingSpeed?.secondMeasuredTime = secondElapsedTime
        }

        if let thirdElapsedTime = test.thirdElapsedTime {
            cga.walkingSpeed?.thirdMeasuredTime = thirdElapsedTime
        }

        if let typedFirstTime = test.typedFirstTime {
            cga.walkingSpeed?.firstTypedTime = typedFirstTime
        }

        if let typedSecondTime = test.typedSecondTime {
            cga.walkingSpeed?.secondTypedTime = typedSecondTime
        }

        if let typedThirdTime = test.typedThirdTime {
            cga.walkingSpeed?.thirdTypedTime = typedThirdTime
        }

        cga.walkingSpeed?.hasStopwatch = test.selectedOption == .firstOption
        cga.walkingSpeed?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: CalfCircumferenceModels.TestData, cgaId: UUID) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.walkingSpeed == nil {
            try createWalkingSpeedInstance(for: cga)
        }

        if let circumference = test.circumference {
            cga.calfCircumference?.measuredCircumference = circumference
        }

        cga.calfCircumference?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: GripStrengthModels.TestData, cgaId: UUID) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.gripStrength == nil {
            try createGripStrengthInstance(for: cga)
        }

        if let firstMeasurement = test.firstMeasurement {
            cga.gripStrength?.firstMeasurement = firstMeasurement
        }

        if let secondMeasurement = test.secondMeasurement {
            cga.gripStrength?.secondMeasurement = secondMeasurement
        }

        if let thirdMeasurement = test.thirdMeasurement {
            cga.gripStrength?.thirdMeasurement = thirdMeasurement
        }

        cga.gripStrength?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: SarcopeniaScreeningModels.TestData, cgaId: UUID) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.sarcopeniaScreening == nil {
            try createSarcopeniaScreeningInstance(for: cga)
        }

        cga.sarcopeniaScreening?.firstQuestionOption = test.firstQuestionOption.rawValue
        cga.sarcopeniaScreening?.secondQuestionOption = test.secondQuestionOption.rawValue
        cga.sarcopeniaScreening?.thirdQuestionOption = test.thirdQuestionOption.rawValue
        cga.sarcopeniaScreening?.fourthQuestionOption = test.fourthQuestionOption.rawValue
        cga.sarcopeniaScreening?.fifthQuestionOption = test.fifthQuestionOption.rawValue
        cga.sarcopeniaScreening?.sixthQuestionOption = test.sixthQuestionOption.rawValue

        cga.sarcopeniaScreening?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    // MARK: - Private Methods

    private func createTimedUpAndGoInstance(for cga: CGA) throws {
        let newTest = TimedUpAndGo(context: context)
        cga.timedUpAndGo = newTest

        try context.save()
    }

    private func createWalkingSpeedInstance(for cga: CGA) throws {
        let newTest = WalkingSpeed(context: context)
        cga.walkingSpeed = newTest

        try context.save()
    }

    private func createCalfCircumferenceInstance(for cga: CGA) throws {
        let newTest = CalfCircumference(context: context)
        cga.calfCircumference = newTest

        try context.save()
    }

    private func createGripStrengthInstance(for cga: CGA) throws {
        let newTest = GripStrength(context: context)
        cga.gripStrength = newTest

        try context.save()
    }

    private func createSarcopeniaScreeningInstance(for cga: CGA) throws {
        let newTest = SarcopeniaScreening(context: context)
        cga.sarcopeniaScreening = newTest

        try context.save()
    }
}
