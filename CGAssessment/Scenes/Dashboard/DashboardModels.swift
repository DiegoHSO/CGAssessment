//
//  DashboardModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 17/09/23.
//

import UIKit

struct DashboardModels {

    struct ViewModel {
        //        let pacients: [Pacient]
        let userName: String?
        let sections: Int = 3
    }

    enum MenuOption {
        case cgaExample
        case lastCGA
        case newCGA
        case patients
        case cgaDomains
        case reports
        case evaluation(id: Int)
        case cgas
    }

    enum Section: Int {
        case recentEvaluation = 0
        case menuOptions
        case evaluationsToReapply
    }

    enum Routing {
        case cga(cgaId: Int)
        case newCGA
        case patients
        case cgaDomains
        case reports
        case cgas
    }
}
