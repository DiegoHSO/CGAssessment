//
//  SuspectedAbuseWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/10/23.
//

import Foundation

class SuspectedAbuseWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = DAOFactory.coreDataDAO, cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getSuspectedAbuseProgress() throws -> SuspectedAbuse? {
        return try dao.fetchCGATest(test: .suspectedAbuse, cgaId: cgaId) as? SuspectedAbuse
    }

    func updateSuspectedAbuseProgress(with data: SuspectedAbuseModels.TestData) throws {
        try dao.updateCGA(with: data, cgaId: cgaId)
    }

}
