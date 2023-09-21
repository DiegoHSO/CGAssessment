//
//  CGADomainsInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 20/09/23.
//

import Foundation

protocol CGADomainsLogic: AnyObject {
    func controllerDidLoad()
    func didSelect(domain: CGADomainsModels.Domain)
}

class CGADomainsInteractor: CGADomainsLogic {

    // MARK: - Private Properties

    private var presenter: CGADomainsPresentationLogic?

    // MARK: - Init

    init(presenter: CGADomainsPresentationLogic) {
        self.presenter = presenter
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        // Not fully implemented
        sendDataToPresenter()
    }

    func didSelect(domain: CGADomainsModels.Domain) {
        presenter?.route(toRoute: .domainTests(domain: domain))
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> CGADomainsModels.ControllerViewModel {
        return CGADomainsModels.ControllerViewModel(domains: [.mobility, .cognitive, .sensory, .functional,
                                                              .nutricional, .social, .polypharmacy,
                                                              .comorbidity, .other], sections: 1)
    }
}
