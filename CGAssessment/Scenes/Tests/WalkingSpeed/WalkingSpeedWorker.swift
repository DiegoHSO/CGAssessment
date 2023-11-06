//
//  WalkingSpeedWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 01/10/23.
//

import Foundation

class WalkingSpeedWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = DAOFactory.coreDataDAO, cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getWalkingSpeedProgress() throws -> WalkingSpeed? {
        return try dao.fetchCGATest(test: .walkingSpeed, cgaId: cgaId) as? WalkingSpeed
    }

    func updateWalkingSpeedProgress(with data: WalkingSpeedModels.TestData) throws {
        try dao.updateCGA(with: data, cgaId: cgaId)
    }

}
