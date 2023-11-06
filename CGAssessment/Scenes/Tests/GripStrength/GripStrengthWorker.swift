//
//  GripStrengthWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 01/10/23.
//

import Foundation

class GripStrengthWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = DAOFactory.coreDataDAO, cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getGripStrengthProgress() throws -> GripStrength? {
        return try dao.fetchCGATest(test: .gripStrength, cgaId: cgaId) as? GripStrength
    }

    func getPatientGender() throws -> Gender {
        guard let patient = try? dao.fetchPatient(cgaId: cgaId),
              let gender = Gender(rawValue: patient.gender) else {
            throw CoreDataErrors.unableToFetchPatient
        }

        return gender
    }

    func updateGripStrengthProgress(with data: GripStrengthModels.TestData) throws {
        try dao.updateCGA(with: data, cgaId: cgaId)
    }

}
