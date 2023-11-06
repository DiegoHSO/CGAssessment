//
//  SarcopeniaScreeningWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 01/10/23.
//

import Foundation

class SarcopeniaScreeningWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = DAOFactory.coreDataDAO, cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getSarcopeniaScreeningProgress() throws -> SarcopeniaScreening? {
        return try dao.fetchCGATest(test: .sarcopeniaScreening, cgaId: cgaId) as? SarcopeniaScreening
    }

    func getPatientGender() throws -> Gender {
        guard let patient = try? dao.fetchPatient(cgaId: cgaId),
              let gender = Gender(rawValue: patient.gender) else {
            throw CoreDataErrors.unableToFetchPatient
        }

        return gender
    }

    func updateSarcopeniaScreeningProgress(with data: SarcopeniaScreeningModels.TestData) throws {
        try dao.updateCGA(with: data, cgaId: cgaId)
    }

}
