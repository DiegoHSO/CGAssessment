//
//  CoreDataDAOProtocol.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 29/10/23.
//

import Foundation

enum CoreDataErrors: Error, Equatable {
    case duplicatedPatient
    case unableToFetchCGA
    case unableToFetchPatient
    case unableToUpdateCGA
    case unableToDeleteCGA
    case unableToDeletePatient
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
    func updateCGA(with test: MoCAModels.TestData, cgaId: UUID?) throws
    func updateCGA(with test: GeriatricDepressionScaleModels.TestData, cgaId: UUID?) throws
    func updateCGA(with test: VisualAcuityAssessmentModels.TestData, cgaId: UUID?) throws
    func updateCGA(with test: HearingLossAssessmentModels.TestData, cgaId: UUID?) throws
    func updateCGA(with test: KatzScaleModels.TestData, cgaId: UUID?) throws
    func updateCGA(with test: LawtonScaleModels.TestData, cgaId: UUID?) throws
    func updateCGA(with test: MiniNutritionalAssessmentModels.TestData, cgaId: UUID?) throws
    func updateCGA(with test: ApgarScaleModels.TestData, cgaId: UUID?) throws
    func updateCGA(with test: ZaritScaleModels.TestData, cgaId: UUID?) throws
    func updateCGA(with test: PolypharmacyCriteriaModels.TestData, cgaId: UUID?) throws
    func updateCGA(with test: CharlsonIndexModels.TestData, cgaId: UUID?) throws
    func updateCGA(with test: SuspectedAbuseModels.TestData, cgaId: UUID?) throws
    func updateCGA(with test: ChemotherapyToxicityRiskModels.TestData, cgaId: UUID?) throws
    func deleteCGA(cgaId: UUID) throws
    func deletePatient(patientId: UUID) throws
}
