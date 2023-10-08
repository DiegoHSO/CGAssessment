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
    func addStandaloneCGA() throws
    func addCGA(for patient: Patient) throws -> UUID
    func addPatient(_ patient: NewCGAModels.PatientData) throws -> UUID
    func fetchCGAs() throws -> [CGA]
    func fetchCGA(cgaId: UUID?) throws -> CGA?
    func fetchPatientCGAs(patientId: UUID) throws -> [CGA]
    func fetchPatients() throws -> [Patient]
    func fetchPatient(patientId: UUID) throws -> Patient?
    func fetchPatient(cgaId: UUID?) throws -> Patient?
    func fetchCGATest(test: SingleDomainModels.Test, cgaId: UUID?) throws -> Any?
    func updateCGA(with test: TimedUpAndGoModels.TestData, cgaId: UUID?) throws
    func updateCGA(with test: WalkingSpeedModels.TestData, cgaId: UUID?) throws
    func updateCGA(with test: CalfCircumferenceModels.TestData, cgaId: UUID?) throws
    func updateCGA(with test: GripStrengthModels.TestData, cgaId: UUID?) throws
    func updateCGA(with test: SarcopeniaScreeningModels.TestData, cgaId: UUID?) throws
    func updateCGA(with test: SarcopeniaAssessmentModels.TestData, cgaId: UUID?) throws
    func updateCGA(with test: MiniMentalStateExamModels.TestData, cgaId: UUID?) throws
    func updateCGA(with test: VerbalFluencyModels.TestData, cgaId: UUID?) throws
    func updateCGA(with test: ClockDrawingModels.TestData, cgaId: UUID?) throws
}

// swiftlint:disable type_body_length file_length
class CoreDataDAO: CoreDataDAOProtocol {

    // MARK: - Private Properties

    private var context: NSManagedObjectContext {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext ?? .init(concurrencyType: .mainQueueConcurrencyType)
    }

    // MARK: - Public Methods

    func addStandaloneCGA() throws {
        if try fetchCGA(cgaId: nil) != nil {
            return
        }

        let newCGA = CGA(context: context)

        newCGA.patient = Patient(context: context)
        newCGA.patient?.gender = 1

        newCGA.timedUpAndGo = TimedUpAndGo(context: context)
        newCGA.timedUpAndGo?.hasStopwatch = false
        newCGA.timedUpAndGo?.typedTime = 9.25
        newCGA.timedUpAndGo?.measuredTime = 8.56
        newCGA.timedUpAndGo?.isDone = true

        newCGA.walkingSpeed = WalkingSpeed(context: context)
        newCGA.walkingSpeed?.hasStopwatch = false
        newCGA.walkingSpeed?.firstMeasuredTime = 13.5
        newCGA.walkingSpeed?.secondMeasuredTime = 10
        newCGA.walkingSpeed?.thirdMeasuredTime = 12
        newCGA.walkingSpeed?.firstTypedTime = 11.4
        newCGA.walkingSpeed?.secondTypedTime = 14.3
        newCGA.walkingSpeed?.thirdTypedTime = 9.6
        newCGA.walkingSpeed?.selectedStopwatch = 3
        newCGA.walkingSpeed?.isDone = true

        newCGA.calfCircumference = CalfCircumference(context: context)
        newCGA.calfCircumference?.measuredCircumference = 31.3
        newCGA.calfCircumference?.isDone = true

        newCGA.gripStrength = GripStrength(context: context)
        newCGA.gripStrength?.firstMeasurement = 27
        newCGA.gripStrength?.secondMeasurement = 26
        newCGA.gripStrength?.thirdMeasurement = 27.5
        newCGA.gripStrength?.isDone = true

        try updateCGA(with: .init(questions: [.sarcopeniaAssessmentFirstQuestion: .thirdOption, .sarcopeniaAssessmentSecondQuestion: .secondOption,
                                              .sarcopeniaAssessmentThirdQuestion: .secondOption, .sarcopeniaAssessmentFourthQuestion: .firstOption,
                                              .sarcopeniaAssessmentFifthQuestion: .secondOption, .sarcopeniaAssessmentSixthQuestion: .secondOption], isDone: true), cgaId: nil)

        newCGA.sarcopeniaAssessment = SarcopeniaAssessment(context: context)
        newCGA.sarcopeniaAssessment?.isDone = true

        try updateCGA(with: .init(questions: [.miniMentalStateExamFirstQuestion: .secondOption, .miniMentalStateExamSecondQuestion: .firstOption,
                                              .miniMentalStateExamThirdQuestion: .secondOption, .miniMentalStateExamFourthQuestion: .firstOption,
                                              .miniMentalStateExamFifthQuestion: .firstOption],
                                  binaryQuestions: [.miniMentalStateExamFirstSectionQuestion: [1: .yes, 2: .not, 3: .not, 4: .yes, 5: .yes],
                                                    .miniMentalStateExamSecondSectionQuestion: [1: .not, 2: .yes, 3: .yes, 4: .yes, 5: .not],
                                                    .miniMentalStateExamThirdSectionQuestion: [1: .not, 2: .yes, 3: .yes],
                                                    .miniMentalStateExamFourthSectionQuestion: [1: .yes, 2: .yes, 3: .yes, 4: .not, 5: .not],
                                                    .miniMentalStateExamFifthSectionQuestion: [1: .yes, 2: .not, 3: .yes],
                                                    .miniMentalStateExamSixthSectionQuestion: [1: .yes, 2: .yes],
                                                    .miniMentalStateExamSeventhSectionQuestion: [1: .yes, 2: .yes, 3: .not]], isDone: true), cgaId: nil)

        try updateCGA(with: .init(elapsedTime: 12.5, selectedOption: .firstOption, countedWords: 19, isDone: true), cgaId: nil)

        try updateCGA(with: .init(binaryQuestions: [
            .outline: [1: .yes, 2: .yes],
            .numbers: [1: .yes, 2: .not, 3: .yes, 4: .not, 5: .yes, 6: .yes],
            .pointers: [1: .not, 2: .yes, 3: .yes, 4: .yes, 5: .not, 6: .yes]
        ], isDone: true), cgaId: nil)

        newCGA.lastModification = Date()
        newCGA.creationDate = Date()

        try context.save()
    }

    func addCGA(for patient: Patient) throws -> UUID {
        let newCGA = CGA(context: context)
        let cgaId = UUID()

        newCGA.patient = patient
        newCGA.lastModification = Date()
        newCGA.creationDate = Date()
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

    func fetchCGA(cgaId: UUID?) throws -> CGA? {
        let request = CGA.fetchRequest() as NSFetchRequest<CGA>
        request.fetchLimit = 1

        let cgaPredicate: NSPredicate

        if let cgaId {
            cgaPredicate = NSPredicate(format: "cgaId == %@", cgaId.uuidString)
        } else {
            cgaPredicate = NSPredicate(format: "cgaId == nil")
        }

        request.predicate = cgaPredicate

        return try context.fetch(request).first
    }

    func fetchPatientCGAs(patientId: UUID) throws -> [CGA] {
        let request = CGA.fetchRequest() as NSFetchRequest<CGA>

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

    func fetchPatient(cgaId: UUID?) throws -> Patient? {
        guard let cga = try fetchCGA(cgaId: cgaId) else {
            throw CoreDataErrors.unableToFetchPatient
        }

        return cga.patient
    }

    func fetchCGATest(test: SingleDomainModels.Test, cgaId: UUID?) throws -> Any? {
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
        case .sarcopeniaScreening:
            return cga?.sarcopeniaScreening
        case .sarcopeniaAssessment:
            return cga?.sarcopeniaAssessment
        case .miniMentalStateExamination:
            return cga?.miniMentalStateExam
        case .verbalFluencyTest:
            return cga?.verbalFluency
        case .clockDrawingTest:
            return cga?.clockDrawing
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
        default:
            return nil
        }
    }

    func updateCGA(with test: TimedUpAndGoModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.timedUpAndGo == nil {
            try createTimedUpAndGoInstance(for: cga)
        }

        if let elapsedTime = test.elapsedTime {
            cga.timedUpAndGo?.measuredTime = NSNumber(value: elapsedTime)
        }

        if let typedElapsedTime = test.typedElapsedTime {
            cga.timedUpAndGo?.typedTime = NSNumber(value: typedElapsedTime)
        }

        cga.timedUpAndGo?.hasStopwatch = test.selectedOption == .firstOption
        cga.timedUpAndGo?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: WalkingSpeedModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.walkingSpeed == nil {
            try createWalkingSpeedInstance(for: cga)
        }

        if let firstElapsedTime = test.firstElapsedTime {
            cga.walkingSpeed?.firstMeasuredTime = NSNumber(value: firstElapsedTime)
        }

        if let secondElapsedTime = test.secondElapsedTime {
            cga.walkingSpeed?.secondMeasuredTime = NSNumber(value: secondElapsedTime)
        }

        if let thirdElapsedTime = test.thirdElapsedTime {
            cga.walkingSpeed?.thirdMeasuredTime = NSNumber(value: thirdElapsedTime)
        }

        if let typedFirstTime = test.typedFirstTime {
            cga.walkingSpeed?.firstTypedTime = NSNumber(value: typedFirstTime)
        }

        if let typedSecondTime = test.typedSecondTime {
            cga.walkingSpeed?.secondTypedTime = NSNumber(value: typedSecondTime)
        }

        if let typedThirdTime = test.typedThirdTime {
            cga.walkingSpeed?.thirdTypedTime = NSNumber(value: typedThirdTime)
        }

        cga.walkingSpeed?.selectedStopwatch = test.selectedStopwatch.rawValue
        cga.walkingSpeed?.hasStopwatch = test.selectedOption == .firstOption
        cga.walkingSpeed?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: CalfCircumferenceModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.calfCircumference == nil {
            try createCalfCircumferenceInstance(for: cga)
        }

        if let circumference = test.circumference {
            cga.calfCircumference?.measuredCircumference = NSNumber(value: circumference)
        }

        cga.calfCircumference?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: GripStrengthModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.gripStrength == nil {
            try createGripStrengthInstance(for: cga)
        }

        if let firstMeasurement = test.firstMeasurement {
            cga.gripStrength?.firstMeasurement = NSNumber(value: firstMeasurement)
        }

        if let secondMeasurement = test.secondMeasurement {
            cga.gripStrength?.secondMeasurement = NSNumber(value: secondMeasurement)
        }

        if let thirdMeasurement = test.thirdMeasurement {
            cga.gripStrength?.thirdMeasurement = NSNumber(value: thirdMeasurement)
        }

        cga.gripStrength?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: SarcopeniaScreeningModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.sarcopeniaScreening == nil {
            try createSarcopeniaScreeningInstance(for: cga)
        }

        let selectableOptions = test.questions.map { key, value in
            let selectableOption = SelectableOption(context: context)
            selectableOption.identifier = key.rawValue
            selectableOption.selectedOption = value.rawValue
            return selectableOption
        }

        cga.sarcopeniaScreening?.selectableOptions = NSSet(array: selectableOptions)

        cga.sarcopeniaScreening?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: SarcopeniaAssessmentModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.sarcopeniaAssessment == nil {
            try createSarcopeniaAssessmentInstance(for: cga)
        }

        cga.sarcopeniaAssessment?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: MiniMentalStateExamModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.miniMentalStateExam == nil {
            try createMiniMentalStateExamInstance(for: cga)
        }

        let binaryOptions = test.binaryQuestions.map { question in
            question.value.map { option in
                let binaryOption = BinaryOption(context: context)
                binaryOption.sectionId = question.key.rawValue
                binaryOption.optionId = option.key
                binaryOption.selectedOption = option.value.rawValue
                return binaryOption
            }
        }

        let binaryOptionsReduced = binaryOptions.reduce([], +)

        let selectableOptions = test.questions.map { key, value in
            let selectableOption = SelectableOption(context: context)
            selectableOption.identifier = key.rawValue
            selectableOption.selectedOption = value.rawValue
            return selectableOption
        }

        cga.miniMentalStateExam?.binaryOptions = NSSet(array: binaryOptionsReduced)
        cga.miniMentalStateExam?.selectableOptions = NSSet(array: selectableOptions)
        cga.miniMentalStateExam?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: VerbalFluencyModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.verbalFluency == nil {
            try createVerbalFluencyInstance(for: cga)
        }

        if let elapsedTime = test.elapsedTime {
            cga.verbalFluency?.elapsedTime = NSNumber(value: elapsedTime)
        }

        cga.verbalFluency?.selectedOption = test.selectedOption.rawValue
        cga.verbalFluency?.countedWords = test.countedWords
        cga.verbalFluency?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: ClockDrawingModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.clockDrawing == nil {
            try createClockDrawingInstance(for: cga)
        }

        let binaryOptions = test.binaryQuestions.map { question in
            question.value.map { option in
                let binaryOption = BinaryOption(context: context)
                binaryOption.sectionId = question.key.rawValue
                binaryOption.optionId = option.key
                binaryOption.selectedOption = option.value.rawValue
                return binaryOption
            }
        }

        let binaryOptionsReduced = binaryOptions.reduce([], +)

        cga.clockDrawing?.binaryOptions = NSSet(array: binaryOptionsReduced)
        cga.clockDrawing?.isDone = test.isDone
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

    private func createSarcopeniaAssessmentInstance(for cga: CGA) throws {
        let newTest = SarcopeniaAssessment(context: context)
        cga.sarcopeniaAssessment = newTest

        try context.save()
    }

    private func createMiniMentalStateExamInstance(for cga: CGA) throws {
        let newTest = MiniMentalStateExam(context: context)
        cga.miniMentalStateExam = newTest

        try context.save()
    }

    private func createVerbalFluencyInstance(for cga: CGA) throws {
        let newTest = VerbalFluency(context: context)
        cga.verbalFluency = newTest

        try context.save()
    }

    private func createClockDrawingInstance(for cga: CGA) throws {
        let newTest = ClockDrawing(context: context)
        cga.clockDrawing = newTest

        try context.save()
    }
}
// swiftlint:enable type_body_length file_length
