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

    init(dao: CoreDataDAOProtocol = CoreDataDAO(), cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getTimedUpAndGoProgress() throws -> TimedUpAndGo? {
        guard let cgaId else {
            throw CoreDataErrors.unableToFetchCGA
        }

        return try dao.fetchCGATest(test: .timedUpAndGo, cgaId: cgaId) as? TimedUpAndGo
    }

    func updateTimedUpAndGoProgress(with data: TimedUpAndGoModels.TestData) throws {
        guard let cgaId else {
            throw CoreDataErrors.unableToUpdateCGA
        }

        try dao.updateCGA(with: data, cgaId: cgaId)
    }

}
