//
//  HearingLossAssessmentWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import Foundation

class HearingLossAssessmentWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol
    private let cgaId: UUID?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = CoreDataDAO(), cgaId: UUID?) {
        self.dao = dao
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func updateHearingLossAssessmentProgress(with data: HearingLossAssessmentModels.TestData) throws {
        try dao.updateCGA(with: data, cgaId: cgaId)
    }

}
