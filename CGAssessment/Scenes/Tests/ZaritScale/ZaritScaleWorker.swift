//
//  ZaritScaleWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 12/10/23.
//

import Foundation

class ZaritScaleWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = DAOFactory.coreDataDAO, cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getZaritScaleProgress() throws -> ZaritScale? {
        return try dao.fetchCGATest(test: .zaritScale, cgaId: cgaId) as? ZaritScale
    }

    func updateZaritScaleProgress(with data: ZaritScaleModels.TestData) throws {
        try dao.updateCGA(with: data, cgaId: cgaId)
    }

}
