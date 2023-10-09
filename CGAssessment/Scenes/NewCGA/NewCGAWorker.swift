//
//  NewCGAWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 30/09/23.
//

import Foundation

class NewCGAWorker {

    // MARK: - Private Properties

    private let dao: CoreDataDAOProtocol

    // MARK: - Init

    init(dao: CoreDataDAOProtocol = CoreDataDAO()) {
        self.dao = dao
    }

    // MARK: - Public Methods

    func getAllPatients() throws -> [Patient] {
        var patients = try dao.fetchPatients()
        patients.sort(by: { ($0.name ?? "") < ($1.name ?? "") })

        return patients
    }

    func savePatient(patientData: NewCGAModels.PatientData) throws -> UUID {
        return try dao.addPatient(patientData)
    }

}
