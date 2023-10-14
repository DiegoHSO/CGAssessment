//
//  DashboardWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 29/09/23.
//

import Foundation

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

        return cgas.first(where: { $0.cgaId != nil })
    }

    func getClosestCGAs() throws -> [CGA] {
        var cgas = try dao.fetchCGAs()
        cgas = cgas.sorted(by: { ($0.lastModification ?? Date()) < ($1.lastModification ?? Date()) }).filter { $0.cgaId != nil }
        cgas = cgas.filter { cga in
            if let lastModification = cga.lastModification, lastModification < Date().addingTimeInterval(-.week),
               lastModification.addingMonth(1).timeIntervalSince(Date()) < 2 * .week {
                return true
            }
            return false
        }
        return Array(cgas.prefix(3))
    }
}
