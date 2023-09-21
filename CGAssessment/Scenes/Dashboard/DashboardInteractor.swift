//
//  DashboardInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 17/09/23.
//

import Foundation

protocol DashboardLogic: FeatureComponentDelegate {
    func controllerDidLoad()
    func didSelect(menuOption: DashboardModels.MenuOption)
}

class DashboardInteractor: DashboardLogic {

    // MARK: - Private Properties

    private var presenter: DashboardPresentationLogic?

    // MARK: - Init

    init(presenter: DashboardPresentationLogic) {
        self.presenter = presenter
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        // Not fully implemented
        sendDataToPresenter()
    }

    func didSelect(menuOption: DashboardModels.MenuOption) {
        switch menuOption {
        case .patients:
            presenter?.route(toRoute: .patients)
        case .cgas:
            presenter?.route(toRoute: .cgas)
        case .newCGA:
            presenter?.route(toRoute: .patients)
        case .reports:
            presenter?.route(toRoute: .reports)
        case .cgaDomains:
            presenter?.route(toRoute: .cgaDomains)
        case .cgaExample:
            presenter?.route(toRoute: .cga(cgaId: -1))
        case .evaluation(let id):
            presenter?.route(toRoute: .cga(cgaId: id))
        case .lastCGA:
            presenter?.route(toRoute: .cga(cgaId: -1))
        }
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> DashboardModels.ViewModel {
        return DashboardModels.ViewModel(userName: "Diego")
    }
}

// MARK: - Internal Delegate extensions

extension DashboardInteractor: FeatureComponentDelegate {
    func didTapComponent(identifier: DashboardModels.MenuOption) {
        switch identifier {
        case .patients:
            presenter?.route(toRoute: .patients)
        case .cgas:
            presenter?.route(toRoute: .cgas)
        case .newCGA:
            presenter?.route(toRoute: .newCGA)
        case .reports:
            presenter?.route(toRoute: .reports)
        case .cgaDomains:
            presenter?.route(toRoute: .cgaDomains)
        default:
            return
        }
    }
}
