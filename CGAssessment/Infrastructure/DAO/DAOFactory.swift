//
//  DAOFactory.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 29/10/23.
//

import Foundation

class DAOFactory {

    // MARK: - Public Properties

    static var coreDataDAO: CoreDataDAOProtocol { isMock ? CoreDataDAOMock() : CoreDataDAO() }

    // MARK: - Private Properties

    private static var isMock: Bool { ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil || ProcessInfo.processInfo.arguments.contains("testMode") }

}
