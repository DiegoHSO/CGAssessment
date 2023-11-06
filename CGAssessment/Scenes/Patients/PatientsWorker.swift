//
//  PatientsWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 03/10/23.
//

import Foundation

class PatientsWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = DAOFactory.coreDataDAO) {
        self.dao = dao
    }

    // MARK: - Public Methods

    func getPatients() throws -> [Patient] {
        return try dao.fetchPatients()
    }

    func deletePatient(patientId: UUID?) throws {
        guard let patientId else {
            throw CoreDataErrors.unableToDeletePatient
        }

        try dao.deletePatient(patientId: patientId)
    }
}
