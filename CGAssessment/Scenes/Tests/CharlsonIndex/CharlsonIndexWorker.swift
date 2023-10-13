//
//  CharlsonIndexWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/10/23.
//

import Foundation

class CharlsonIndexWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = CoreDataDAO(), cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getCharlsonIndexProgress() throws -> CharlsonIndex? {
        return try dao.fetchCGATest(test: .charlsonIndex, cgaId: cgaId) as? CharlsonIndex
    }

    func updateCharlsonIndexProgress(with data: CharlsonIndexModels.TestData) throws {
        try dao.updateCGA(with: data, cgaId: cgaId)
    }

    func getPatientBirthDate() throws -> Date? {
        guard let patient = try dao.fetchPatient(cgaId: cgaId) else {
            throw CoreDataErrors.unableToFetchPatient
        }

        return patient.birthDate
    }

}
