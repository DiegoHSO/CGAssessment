//
//  CGADomainsWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 30/09/23.
//

import Foundation

class CGADomainsWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = CoreDataDAO()) {
        self.dao = dao
    }

    // MARK: - Public Methods

    func saveCGA(for patient: UUID) throws -> UUID {
        guard let patient = try dao.fetchPatient(patientId: patient) else {
            throw CoreDataErrors.unableToFetchPatient
        }

        return try dao.addCGA(for: patient)
    }

    func getCGA(with cgaId: UUID?) throws -> CGA {
        guard let cga = try dao.fetchCGA(cgaId: cgaId) else {
            throw CoreDataErrors.unableToFetchCGA
        }

        return cga
    }

}
