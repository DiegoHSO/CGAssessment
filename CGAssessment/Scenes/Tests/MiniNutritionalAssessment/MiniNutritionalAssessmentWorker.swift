//
//  MiniNutritionalAssessmentWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import Foundation

class MiniNutritionalAssessmentWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = CoreDataDAO(), cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getMiniNutritionalAssessmentProgress() throws -> MiniNutritionalAssessment? {
        return try dao.fetchCGATest(test: .miniNutritionalAssessment, cgaId: cgaId) as? MiniNutritionalAssessment
    }

    func updateMiniNutritionalAssessmentProgress(with data: MiniNutritionalAssessmentModels.TestData) throws {
        try dao.updateCGA(with: data, cgaId: cgaId)
    }

}
