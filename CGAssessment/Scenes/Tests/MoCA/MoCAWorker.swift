//
//  MoCAWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import Foundation

class MoCAWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = CoreDataDAO(), cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getMoCAProgress() throws -> MoCA? {
        return try dao.fetchCGATest(test: .moca, cgaId: cgaId) as? MoCA
    }

    func updateMoCAProgress(with data: MoCAModels.TestData) throws {
        try dao.updateCGA(with: data, cgaId: cgaId)
    }

}
