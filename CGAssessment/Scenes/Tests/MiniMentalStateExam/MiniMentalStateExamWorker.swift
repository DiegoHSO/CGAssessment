//
//  MiniMentalStateExamWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 05/10/23.
//

import Foundation

class MiniMentalStateExamWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = CoreDataDAO(), cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getMiniMentalStateExamProgress() throws -> MiniMentalStateExam? {
        return try dao.fetchCGATest(test: .miniMentalStateExamination, cgaId: cgaId) as? MiniMentalStateExam
    }

    func updateMiniMentalStateExamProgress(with data: MiniMentalStateExamModels.TestData) throws {
        try dao.updateCGA(with: data, cgaId: cgaId)
    }

}
