//
//  TimedUpAndGoWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 01/10/23.
//

import Foundation

class TimedUpAndGoWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = DAOFactory.coreDataDAO, cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getTimedUpAndGoProgress() throws -> TimedUpAndGo? {
        return try dao.fetchCGATest(test: .timedUpAndGo, cgaId: cgaId) as? TimedUpAndGo
    }

    func updateTimedUpAndGoProgress(with data: TimedUpAndGoModels.TestData) throws {
        try dao.updateCGA(with: data, cgaId: cgaId)
    }

}
