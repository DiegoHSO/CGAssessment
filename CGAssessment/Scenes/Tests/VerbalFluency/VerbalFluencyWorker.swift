//
//  VerbalFluencyWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import Foundation

class VerbalFluencyWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = DAOFactory.coreDataDAO, cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getVerbalFluencyProgress() throws -> VerbalFluency? {
        return try dao.fetchCGATest(test: .verbalFluencyTest, cgaId: cgaId) as? VerbalFluency
    }

    func updateVerbalFluencyProgress(with data: VerbalFluencyModels.TestData) throws {
        try dao.updateCGA(with: data, cgaId: cgaId)
    }

}
