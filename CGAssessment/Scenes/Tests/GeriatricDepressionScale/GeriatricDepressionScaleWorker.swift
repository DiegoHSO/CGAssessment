//
//  GeriatricDepressionScaleWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 09/10/23.
//

import Foundation

class GeriatricDepressionScaleWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = DAOFactory.coreDataDAO, cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getGeriatricDepressionScaleProgress() throws -> GeriatricDepressionScale? {
        return try dao.fetchCGATest(test: .geriatricDepressionScale, cgaId: cgaId) as? GeriatricDepressionScale
    }

    func updateGeriatricDepressionScaleProgress(with data: GeriatricDepressionScaleModels.TestData) throws {
        try dao.updateCGA(with: data, cgaId: cgaId)
    }

}
