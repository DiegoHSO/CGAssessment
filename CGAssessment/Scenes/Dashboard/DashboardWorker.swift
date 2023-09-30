//
//  DashboardWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 29/09/23.
//

import CloudKit

class DashboardWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = CoreDataDAO()) {
        self.dao = dao
    }

    // MARK: - Public Methods

    func getLatestCGA() throws -> CGA? {
        var cgas = try dao.fetchCGAs()
        cgas.sort(by: { ($0.lastModification ?? Date()) > ($1.lastModification ?? Date()) })

        return cgas.first
    }

    func getClosestCGAs() throws -> [CGA] {
        let cgas = try dao.fetchCGAs()
        return Array(cgas.prefix(3))
    }
}
