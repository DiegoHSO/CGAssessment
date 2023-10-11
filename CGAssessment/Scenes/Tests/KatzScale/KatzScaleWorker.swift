//
//  KatzScaleWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import Foundation

class KatzScaleWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = CoreDataDAO(), cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getKatzScaleProgress() throws -> KatzScale? {
        return try dao.fetchCGATest(test: .katzScale, cgaId: cgaId) as? KatzScale
    }

    func updateKatzScaleProgress(with data: KatzScaleModels.TestData) throws {
        try dao.updateCGA(with: data, cgaId: cgaId)
    }

}
