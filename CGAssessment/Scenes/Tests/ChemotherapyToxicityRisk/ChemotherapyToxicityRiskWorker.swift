//
//  ChemotherapyToxicityRiskWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/10/23.
//

import Foundation

class ChemotherapyToxicityRiskWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = DAOFactory.coreDataDAO, cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getChemotherapyToxicityRiskProgress() throws -> ChemotherapyToxicityRisk? {
        return try dao.fetchCGATest(test: .chemotherapyToxicityRisk, cgaId: cgaId) as? ChemotherapyToxicityRisk
    }

    func updateChemotherapyToxicityRiskProgress(with data: ChemotherapyToxicityRiskModels.TestData) throws {
        try dao.updateCGA(with: data, cgaId: cgaId)
    }

    func getPatientBirthDate() throws -> Date? {
        guard let patient = try dao.fetchPatient(cgaId: cgaId) else {
            throw CoreDataErrors.unableToFetchPatient
        }

        return patient.birthDate
    }

    func getPatientGender() throws -> Gender {
        guard let patient = try dao.fetchPatient(cgaId: cgaId),
              let gender = Gender(rawValue: patient.gender) else {
            throw CoreDataErrors.unableToFetchPatient
        }

        return gender
    }

}
