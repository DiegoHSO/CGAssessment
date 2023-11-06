//
//  ApgarScaleWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 12/10/23.
//

import Foundation

class ApgarScaleWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = DAOFactory.coreDataDAO, cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getApgarScaleProgress() throws -> ApgarScale? {
        return try dao.fetchCGATest(test: .apgarScale, cgaId: cgaId) as? ApgarScale
    }

    func updateApgarScaleProgress(with data: ApgarScaleModels.TestData) throws {
        try dao.updateCGA(with: data, cgaId: cgaId)
    }

}
