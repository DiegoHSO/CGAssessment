//
//  SingleDomainWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 30/09/23.
//

import Foundation

class SingleDomainWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = CoreDataDAO()) {
        self.dao = dao
    }

    // MARK: - Public Methods

    func getCGA(with cgaId: UUID?) throws -> CGA {
        guard let cga = try dao.fetchCGA(cgaId: cgaId) else {
            throw CoreDataErrors.unableToFetchCGA
        }

        return cga
    }

}
