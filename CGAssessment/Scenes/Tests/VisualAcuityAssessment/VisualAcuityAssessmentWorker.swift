//
//  VisualAcuityAssessmentWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 10/10/23.
//

import Foundation


class VisualAcuityAssessmentWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = CoreDataDAO(), cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getVisualAcuityAssessmentProgress() throws -> VisualAcuityAssessment? {
        return try dao.fetchCGATest(test: .verbalFluencyTest, cgaId: cgaId) as? VisualAcuityAssessment
    }

    func updateVisualAcuityAssessmentProgress(with data: VisualAcuityAssessmentModels.TestData) throws {
        try dao.updateCGA(with: data, cgaId: cgaId)
    }

}
