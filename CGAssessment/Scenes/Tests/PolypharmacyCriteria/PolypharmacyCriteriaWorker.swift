//
//  PolypharmacyCriteriaWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import Foundation

class PolypharmacyCriteriaWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = DAOFactory.coreDataDAO, cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getPolypharmacyCriteriaProgress() throws -> PolypharmacyCriteria? {
        return try dao.fetchCGATest(test: .polypharmacyCriteria, cgaId: cgaId) as? PolypharmacyCriteria
    }

    func updatePolypharmacyCriteriaProgress(with data: PolypharmacyCriteriaModels.TestData) throws {
        try dao.updateCGA(with: data, cgaId: cgaId)
    }

}
