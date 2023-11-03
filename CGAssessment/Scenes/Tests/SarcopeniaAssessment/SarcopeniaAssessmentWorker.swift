//
//  SarcopeniaAssessmentWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 01/10/23.
//

import Foundation

class SarcopeniaAssessmentWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = DAOFactory.coreDataDAO, cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getSarcopeniaAssessmentProgress() throws -> SarcopeniaAssessment? {
        return try dao.fetchCGATest(test: .sarcopeniaAssessment, cgaId: cgaId) as? SarcopeniaAssessment
    }

    func getPatientGender() throws -> Gender {
        guard let patient = try? dao.fetchPatient(cgaId: cgaId),
              let gender = Gender(rawValue: patient.gender) else {
            throw CoreDataErrors.unableToFetchPatient
        }

        return gender
    }

    func getGripStrengthProgress() throws -> GripStrength? {
        return try dao.fetchCGATest(test: .gripStrength, cgaId: cgaId) as? GripStrength
    }

    func getCalfCircumferenceProgress() throws -> CalfCircumference? {
        return try dao.fetchCGATest(test: .calfCircumference, cgaId: cgaId) as? CalfCircumference
    }

    func getTimedUpAndGoProgress() throws -> TimedUpAndGo? {
        return try dao.fetchCGATest(test: .timedUpAndGo, cgaId: cgaId) as? TimedUpAndGo
    }

    func getWalkingSpeedProgress() throws -> WalkingSpeed? {
        return try dao.fetchCGATest(test: .walkingSpeed, cgaId: cgaId) as? WalkingSpeed
    }

    func updateSarcopeniaAssessmentProgress(with data: SarcopeniaAssessmentModels.TestData) throws {
        try dao.updateCGA(with: data, cgaId: cgaId)
    }

}
