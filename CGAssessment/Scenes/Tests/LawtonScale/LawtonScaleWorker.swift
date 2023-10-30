//
//  LawtonScaleWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import Foundation

class LawtonScaleWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = DAOFactory.coreDataDAO, cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getLawtonScaleProgress() throws -> LawtonScale? {
        return try dao.fetchCGATest(test: .lawtonScale, cgaId: cgaId) as? LawtonScale
    }

    func updateLawtonScaleProgress(with data: LawtonScaleModels.TestData) throws {
        try dao.updateCGA(with: data, cgaId: cgaId)
    }

}
