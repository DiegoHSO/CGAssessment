//
//  ClockDrawingWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import Foundation

class ClockDrawingWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = CoreDataDAO(), cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func getClockDrawingProgress() throws -> ClockDrawing? {
        return try dao.fetchCGATest(test: .clockDrawingTest, cgaId: cgaId) as? ClockDrawing
    }

    func updateClockDrawingProgress(with data: ClockDrawingModels.TestData) throws {
        try dao.updateCGA(with: data, cgaId: cgaId)
    }

}
