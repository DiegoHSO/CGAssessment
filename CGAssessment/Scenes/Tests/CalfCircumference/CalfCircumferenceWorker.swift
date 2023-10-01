//
//  CalfCircumferenceWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 01/10/23.
//

import Foundation

class CalfCircumferenceWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = CoreDataDAO(), cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getCalfCircumferenceProgress() throws -> CalfCircumference? {
        guard let cgaId else {
            throw CoreDataErrors.unableToFetchCGA
        }

        return try dao.fetchCGATest(test: .calfCircumference, cgaId: cgaId) as? CalfCircumference
    }

    func updateCalfCircumferenceProgress(with data: CalfCircumferenceModels.TestData) throws {
        guard let cgaId else {
            throw CoreDataErrors.unableToUpdateCGA
        }

        try dao.updateCGA(with: data, cgaId: cgaId)
    }

}
