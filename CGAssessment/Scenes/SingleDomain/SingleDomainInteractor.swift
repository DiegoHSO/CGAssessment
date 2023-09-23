//
//  SingleDomainInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 23/09/23.
//

import Foundation

protocol SingleDomainLogic: AnyObject {
    func controllerDidLoad()
    func didSelect(test: SingleDomainModels.Test)
}

class SingleDomainInteractor: SingleDomainLogic {

    // MARK: - Private Properties

    private var presenter: SingleDomainPresentationLogic?
    private var domain: CGADomainsModels.Domain

    // MARK: - Init

    init(presenter: SingleDomainPresentationLogic, domain: CGADomainsModels.Domain) {
        self.presenter = presenter
        self.domain = domain
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        // Not fully implemented
        sendDataToPresenter()
    }

    func didSelect(test: SingleDomainModels.Test) {
        presenter?.route(toRoute: .domainTest(test: test))
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> SingleDomainModels.ControllerViewModel {
        return SingleDomainModels.ControllerViewModel(domains: [.mobility, .cognitive, .sensory, .functional,
                                                              .nutricional, .social, .polypharmacy,
                                                              .comorbidity, .other], sections: 1)
    }
}
