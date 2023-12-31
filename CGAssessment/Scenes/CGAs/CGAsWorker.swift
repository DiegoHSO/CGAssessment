//
//  CGAsWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 01/10/23.
//

import Foundation

class CGAsWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = DAOFactory.coreDataDAO) {
        self.dao = dao
    }

    // MARK: - Public Methods

    func getCGAs(for patient: UUID? = nil) throws -> [CGA] {
        if let patient {
            return try dao.fetchPatientCGAs(patientId: patient)
        } else {
            return try dao.fetchCGAs()
        }
    }

    func getPatients() throws -> [Patient] {
        return try dao.fetchPatients()
    }

    func deleteCGA(cgaId: UUID?) throws {
        guard let cgaId else {
            throw CoreDataErrors.unableToDeleteCGA
        }

        try dao.deleteCGA(cgaId: cgaId)
    }

}
