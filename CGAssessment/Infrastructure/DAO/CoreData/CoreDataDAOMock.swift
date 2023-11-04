//
//  CoreDataDAOMock.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 29/10/23.
//

import CoreData
import Foundation

class CoreDataDAOMock: CoreDataDAOProtocol {

    // MARK: - Private Properties

    private lazy var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        let container = NSPersistentCloudKitContainer(name: "CGAssessment")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Public Methods

    func addStandaloneCGA() throws {
        let mockCgaId = UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3")

        if try fetchCGA(cgaId: mockCgaId) != nil {
            return
        }

        let newCGA = CGA(context: context)
        newCGA.cgaId = mockCgaId

        newCGA.patient = Patient(context: context)
        newCGA.patient?.gender = 1
        newCGA.patient?.birthDate = Date().addingYear(-75).removingTimeComponents()
        newCGA.patient?.name = "Mock CGA"
        newCGA.patient?.patientId = UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3")

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

        try updateCGA(with: SarcopeniaScreeningModels.TestData(questions: [.sarcopeniaAssessmentFirstQuestion: .thirdOption, .sarcopeniaAssessmentSecondQuestion: .secondOption,
                                                                           .sarcopeniaAssessmentThirdQuestion: .secondOption, .sarcopeniaAssessmentFourthQuestion: .firstOption,
                                                                           .sarcopeniaAssessmentFifthQuestion: .secondOption, .sarcopeniaAssessmentSixthQuestion: .secondOption], isDone: true), cgaId: mockCgaId)

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
                                                    .miniMentalStateExamSeventhSectionQuestion: [1: .yes, 2: .yes, 3: .not]], isDone: true), cgaId: mockCgaId)

        try updateCGA(with: .init(elapsedTime: 12.5, selectedOption: .firstOption, countedWords: 19, isDone: true), cgaId: mockCgaId)

        try updateCGA(with: ClockDrawingModels.TestData(binaryQuestions: [
            .outline: [1: .yes, 2: .yes],
            .numbers: [1: .yes, 2: .not, 3: .yes, 4: .not, 5: .yes, 6: .yes],
            .pointers: [1: .not, 2: .yes, 3: .yes, 4: .yes, 5: .not, 6: .yes]
        ], isDone: true), cgaId: mockCgaId)

        let rawBinaryQuestions: MoCAModels.RawBinaryQuestions = [.visuospatial: [1: .yes, 2: .not, 3: .yes, 4: .yes, 5: .yes],
                                                                 .naming: [1: .not, 2: .yes, 3: .yes],
                                                                 .mocaFourthSectionSecondInstruction: [1: .yes, 2: .yes],
                                                                 .mocaFourthSectionThirdInstruction: [1: .yes],
                                                                 .mocaFourthSectionFourthInstruction: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes],
                                                                 .language: [1: .yes, 2: .not],
                                                                 .abstraction: [1: .yes, 2: .yes],
                                                                 .delayedRecall: [1: .yes, 2: .yes, 3: .not, 4: .yes, 5: .yes],
                                                                 .orientation: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes, 6: .yes]]

        try updateCGA(with: .init(binaryQuestions: rawBinaryQuestions,
                                  selectedEducationOption: .firstOption,
                                  countedWords: 14, circlesImage: nil,
                                  watchImage: nil, isDone: true), cgaId: mockCgaId)

        try updateCGA(with: GeriatricDepressionScaleModels.TestData(questions: [.geriatricDepressionScaleQuestionOne: .firstOption, .geriatricDepressionScaleQuestionTwo: .firstOption, .geriatricDepressionScaleQuestionThree: .firstOption,
                                                                                .geriatricDepressionScaleQuestionFour: .firstOption, .geriatricDepressionScaleQuestionFive: .secondOption,
                                                                                .geriatricDepressionScaleQuestionSix: .secondOption, .geriatricDepressionScaleQuestionSeven: .secondOption,
                                                                                .geriatricDepressionScaleQuestionEight: .secondOption, .geriatricDepressionScaleQuestionNine: .secondOption,
                                                                                .geriatricDepressionScaleQuestionTen: .secondOption, .geriatricDepressionScaleQuestionEleven: .firstOption,
                                                                                .geriatricDepressionScaleQuestionTwelve: .firstOption, .geriatricDepressionScaleQuestionThirteen: .firstOption,
                                                                                .geriatricDepressionScaleQuestionFourteen: .firstOption, .geriatricDepressionScaleQuestionFifteen: .secondOption
        ], isDone: true), cgaId: mockCgaId)

        try updateCGA(with: .init(selectedOption: .ninthOption, isDone: true), cgaId: mockCgaId)
        try updateCGA(with: HearingLossAssessmentModels.TestData.init(isDone: true), cgaId: mockCgaId)

        try updateCGA(with: KatzScaleModels.TestData(questions: [
            .katzScaleQuestionOne: .firstOption, .katzScaleQuestionTwo: .secondOption, .katzScaleQuestionThree: .firstOption,
            .katzScaleQuestionFour: .firstOption, .katzScaleQuestionFive: .firstOption, .katzScaleQuestionSix: .firstOption
        ], isDone: true), cgaId: mockCgaId)

        try updateCGA(with: LawtonScaleModels.TestData(questions: [
            .telephone: .thirdOption, .trips: .firstOption, .shopping: .firstOption, .mealPreparation: .firstOption,
            .housework: .secondOption, .medicine: .firstOption, .money: .firstOption
        ], isDone: true), cgaId: mockCgaId)

        try updateCGA(with: .init(questions: [
            .miniNutritionalAssessmentFirstQuestion: .thirdOption, .miniNutritionalAssessmentSecondQuestion: .fourthOption,
            .miniNutritionalAssessmentThirdQuestion: .thirdOption, .miniNutritionalAssessmentFourthQuestion: .firstOption,
            .miniNutritionalAssessmentFifthQuestion: .thirdOption, .miniNutritionalAssessmentSeventhQuestion: .none
        ], height: 174, weight: 80.5, isExtraQuestionSelected: false, isDone: true), cgaId: mockCgaId)

        try updateCGA(with: ApgarScaleModels.TestData(questions: [.apgarScaleQuestionOne: .secondOption, .apgarScaleQuestionTwo: .thirdOption, .apgarScaleQuestionThree: .thirdOption,
                                                                  .apgarScaleQuestionFour: .firstOption, .apgarScaleQuestionFive: .thirdOption
        ], isDone: true), cgaId: mockCgaId)

        try updateCGA(with: ZaritScaleModels.TestData(questions: [.zaritScaleQuestionOne: .firstOption, .zaritScaleQuestionTwo: .firstOption, .zaritScaleQuestionThree: .firstOption,
                                                                  .zaritScaleQuestionFour: .firstOption, .zaritScaleQuestionFive: .secondOption, .zaritScaleQuestionSix: .secondOption,
                                                                  .zaritScaleQuestionSeven: .secondOption
        ], isDone: true), cgaId: mockCgaId)

        try updateCGA(with: .init(numberOfMedicines: 3, isDone: true), cgaId: mockCgaId)

        try updateCGA(with: CharlsonIndexModels.TestData(binaryQuestions: [
            .charlsonIndexMainQuestion: [1: .yes, 2: .not, 3: .yes, 4: .not, 5: .not, 6: .not,
                                         7: .not, 8: .not, 9: .not, 10: .not, 11: .not, 12: .not,
                                         13: .not, 14: .not, 15: .not, 16: .not, 17: .not, 18: .not]
        ], isDone: true), cgaId: mockCgaId)

        try updateCGA(with: SuspectedAbuseModels.TestData(selectedOption: .firstOption, typedText: LocalizedTable.suspectedAbuseExample.localized,
                                                          isDone: true), cgaId: mockCgaId)

        try updateCGA(with: ChemotherapyToxicityRiskModels.TestData(questions: [
            .chemotherapyToxicityRiskQuestionOne: .secondOption, .chemotherapyToxicityRiskQuestionTwo: .firstOption,
            .chemotherapyToxicityRiskQuestionThree: .secondOption, .chemotherapyToxicityRiskQuestionFour: .secondOption,
            .chemotherapyToxicityRiskQuestionFive: .secondOption, .chemotherapyToxicityRiskQuestionSix: .secondOption,
            .chemotherapyToxicityRiskQuestionSeven: .secondOption, .chemotherapyToxicityRiskQuestionEight: .firstOption,
            .chemotherapyToxicityRiskQuestionNine: .secondOption, .chemotherapyToxicityRiskQuestionTen: .secondOption,
            .chemotherapyToxicityRiskQuestionEleven: .secondOption
        ], isDone: true), cgaId: mockCgaId)

        newCGA.lastModification = Date().addingMonth(-1).removingTimeComponents()
        newCGA.creationDate = Date().addingMonth(-2).removingTimeComponents()

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
        return try fetchCGAs().first(where: { $0.cgaId == cgaId })
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
            return cga?.moCA
        case .geriatricDepressionScale:
            return cga?.geriatricDepressionScale
        case .visualAcuityAssessment:
            return cga?.visualAcuityAssessment
        case .hearingLossAssessment:
            return cga?.hearingLossAssessment
        case .katzScale:
            return cga?.katzScale
        case .lawtonScale:
            return cga?.lawtonScale
        case .miniNutritionalAssessment:
            return cga?.miniNutritionalAssessment
        case .apgarScale:
            return cga?.apgarScale
        case .zaritScale:
            return cga?.zaritScale
        case .polypharmacyCriteria:
            return cga?.polypharmacyCriteria
        case .charlsonIndex:
            return cga?.charlsonIndex
        case .suspectedAbuse:
            return cga?.suspectedAbuse
        case .cardiovascularRiskEstimation:
            return nil
        case .chemotherapyToxicityRisk:
            return cga?.chemotherapyToxicityRisk
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

    func updateCGA(with test: MoCAModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.moCA == nil {
            try createMoCAInstance(for: cga)
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

        cga.moCA?.binaryOptions = NSSet(array: binaryOptionsReduced)
        cga.moCA?.circlesImage = test.circlesImage
        cga.moCA?.watchImage = test.watchImage
        cga.moCA?.countedWords = test.countedWords
        cga.moCA?.selectedOption = test.selectedEducationOption.rawValue
        cga.moCA?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: GeriatricDepressionScaleModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.geriatricDepressionScale == nil {
            try createGeriatricDepressionScaleInstance(for: cga)
        }

        let selectableOptions = test.questions.map { key, value in
            let selectableOption = SelectableOption(context: context)
            selectableOption.identifier = key.rawValue
            selectableOption.selectedOption = value.rawValue
            return selectableOption
        }

        cga.geriatricDepressionScale?.selectableOptions = NSSet(array: selectableOptions)
        cga.geriatricDepressionScale?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: VisualAcuityAssessmentModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.visualAcuityAssessment == nil {
            try createVisualAcuityAssessmentInstance(for: cga)
        }

        cga.visualAcuityAssessment?.selectedOption = test.selectedOption.rawValue
        cga.visualAcuityAssessment?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: HearingLossAssessmentModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.hearingLossAssessment == nil {
            try createHearingLossAssessmentInstance(for: cga)
        }

        cga.hearingLossAssessment?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: KatzScaleModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.katzScale == nil {
            try createKatzScaleInstance(for: cga)
        }

        let selectableOptions = test.questions.map { key, value in
            let selectableOption = SelectableOption(context: context)
            selectableOption.identifier = key.rawValue
            selectableOption.selectedOption = value.rawValue
            return selectableOption
        }

        cga.katzScale?.selectableOptions = NSSet(array: selectableOptions)
        cga.katzScale?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: LawtonScaleModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.lawtonScale == nil {
            try createLawtonScaleInstance(for: cga)
        }

        let selectableOptions = test.questions.map { key, value in
            let selectableOption = SelectableOption(context: context)
            selectableOption.identifier = key.rawValue
            selectableOption.selectedOption = value.rawValue
            return selectableOption
        }

        cga.lawtonScale?.selectableOptions = NSSet(array: selectableOptions)
        cga.lawtonScale?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: MiniNutritionalAssessmentModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.miniNutritionalAssessment == nil {
            try createMiniNutritionalAssessmentInstance(for: cga)
        }

        if let height = test.height {
            cga.miniNutritionalAssessment?.height = NSNumber(value: height)
        }

        if let weight = test.weight {
            cga.miniNutritionalAssessment?.weight = NSNumber(value: weight)
        }

        let selectableOptions = test.questions.map { key, value in
            let selectableOption = SelectableOption(context: context)
            selectableOption.identifier = key.rawValue
            selectableOption.selectedOption = value.rawValue
            return selectableOption
        }

        cga.miniNutritionalAssessment?.selectableOptions = NSSet(array: selectableOptions)
        cga.miniNutritionalAssessment?.isExtraQuestionSelected = test.isExtraQuestionSelected
        cga.miniNutritionalAssessment?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: ApgarScaleModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.apgarScale == nil {
            try createApgarScaleInstance(for: cga)
        }

        let selectableOptions = test.questions.map { key, value in
            let selectableOption = SelectableOption(context: context)
            selectableOption.identifier = key.rawValue
            selectableOption.selectedOption = value.rawValue
            return selectableOption
        }

        cga.apgarScale?.selectableOptions = NSSet(array: selectableOptions)
        cga.apgarScale?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: ZaritScaleModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.zaritScale == nil {
            try createZaritScaleInstance(for: cga)
        }

        let selectableOptions = test.questions.map { key, value in
            let selectableOption = SelectableOption(context: context)
            selectableOption.identifier = key.rawValue
            selectableOption.selectedOption = value.rawValue
            return selectableOption
        }

        cga.zaritScale?.selectableOptions = NSSet(array: selectableOptions)
        cga.zaritScale?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: PolypharmacyCriteriaModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.polypharmacyCriteria == nil {
            try createPolypharmacyCriteriaInstance(for: cga)
        }

        cga.polypharmacyCriteria?.numberOfMedicines = test.numberOfMedicines ?? 0
        cga.polypharmacyCriteria?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: CharlsonIndexModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.charlsonIndex == nil {
            try createCharlsonIndexInstance(for: cga)
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

        cga.charlsonIndex?.binaryOptions = NSSet(array: binaryOptionsReduced)
        cga.charlsonIndex?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: SuspectedAbuseModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.suspectedAbuse == nil {
            try createSuspectedAbuseInstance(for: cga)
        }

        cga.suspectedAbuse?.selectedOption = test.selectedOption.rawValue
        cga.suspectedAbuse?.typedText = test.typedText
        cga.suspectedAbuse?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func updateCGA(with test: ChemotherapyToxicityRiskModels.TestData, cgaId: UUID?) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToFetchCGA }

        if cga.chemotherapyToxicityRisk == nil {
            try createChemotherapyToxicityRiskInstance(for: cga)
        }

        let selectableOptions = test.questions.map { key, value in
            let selectableOption = SelectableOption(context: context)
            selectableOption.identifier = key.rawValue
            selectableOption.selectedOption = value.rawValue
            return selectableOption
        }

        cga.chemotherapyToxicityRisk?.selectableOptions = NSSet(array: selectableOptions)
        cga.chemotherapyToxicityRisk?.isDone = test.isDone
        cga.lastModification = Date()

        try context.save()
    }

    func deleteCGA(cgaId: UUID) throws {
        guard let cga = try fetchCGA(cgaId: cgaId) else { throw CoreDataErrors.unableToDeleteCGA }

        context.delete(cga)

        try context.save()
    }

    func deletePatient(patientId: UUID) throws {
        guard let patient = try fetchPatient(patientId: patientId) else { throw CoreDataErrors.unableToDeletePatient }

        if let cgas = patient.cgas?.allObjects as? [CGA] {
            try cgas.forEach { cga in
                if let cgaId = cga.cgaId { try self.deleteCGA(cgaId: cgaId) }
            }
        }

        context.delete(patient)

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

    private func createMoCAInstance(for cga: CGA) throws {
        let newTest = MoCA(context: context)
        cga.moCA = newTest

        try context.save()
    }

    private func createGeriatricDepressionScaleInstance(for cga: CGA) throws {
        let newTest = GeriatricDepressionScale(context: context)
        cga.geriatricDepressionScale = newTest

        try context.save()
    }

    private func createVisualAcuityAssessmentInstance(for cga: CGA) throws {
        let newTest = VisualAcuityAssessment(context: context)
        cga.visualAcuityAssessment = newTest

        try context.save()
    }

    private func createHearingLossAssessmentInstance(for cga: CGA) throws {
        let newTest = HearingLossAssessment(context: context)
        cga.hearingLossAssessment = newTest

        try context.save()
    }

    private func createKatzScaleInstance(for cga: CGA) throws {
        let newTest = KatzScale(context: context)
        cga.katzScale = newTest

        try context.save()
    }

    private func createLawtonScaleInstance(for cga: CGA) throws {
        let newTest = LawtonScale(context: context)
        cga.lawtonScale = newTest

        try context.save()
    }

    private func createMiniNutritionalAssessmentInstance(for cga: CGA) throws {
        let newTest = MiniNutritionalAssessment(context: context)
        cga.miniNutritionalAssessment = newTest

        try context.save()
    }

    private func createApgarScaleInstance(for cga: CGA) throws {
        let newTest = ApgarScale(context: context)
        cga.apgarScale = newTest

        try context.save()
    }

    private func createZaritScaleInstance(for cga: CGA) throws {
        let newTest = ZaritScale(context: context)
        cga.zaritScale = newTest

        try context.save()
    }

    private func createPolypharmacyCriteriaInstance(for cga: CGA) throws {
        let newTest = PolypharmacyCriteria(context: context)
        cga.polypharmacyCriteria = newTest

        try context.save()
    }

    private func createCharlsonIndexInstance(for cga: CGA) throws {
        let newTest = CharlsonIndex(context: context)
        cga.charlsonIndex = newTest

        try context.save()
    }

    private func createSuspectedAbuseInstance(for cga: CGA) throws {
        let newTest = SuspectedAbuse(context: context)
        cga.suspectedAbuse = newTest

        try context.save()
    }

    private func createChemotherapyToxicityRiskInstance(for cga: CGA) throws {
        let newTest = ChemotherapyToxicityRisk(context: context)
        cga.chemotherapyToxicityRisk = newTest

        try context.save()
    }
}
