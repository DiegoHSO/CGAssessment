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
    private var worker: CGADomainsWorker?
    private var domains: [CGADomainsModels.Domain: CGADomainsModels.Tests] = [:]
    private var patientId: UUID?
    private var cgaId: UUID?

    // MARK: - Init

    init(presenter: CGADomainsPresentationLogic, worker: CGADomainsWorker, patientId: UUID?, cgaId: UUID? = nil) {
        self.presenter = presenter
        self.worker = worker
        self.patientId = patientId
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        createNewCGAIfNeeded()
        computeViewModelData()
        sendDataToPresenter()
    }

    func didSelect(domain: CGADomainsModels.Domain) {
        presenter?.route(toRoute: .domainTests(domain: domain, cgaId: cgaId))
    }

    // MARK: - Private Methods

    private func createNewCGAIfNeeded() {
        guard cgaId == nil, let patientId else { return }
        cgaId = try? worker?.saveCGA(for: patientId)
    }

    private func computeViewModelData() {
        guard let cgaId, let cga = try? worker?.getCGA(with: cgaId) else { return }

        domains.updateValue([.timedUpAndGo: cga.timedUpAndGo?.isDone == true,
                             .walkingSpeed: cga.walkingSpeed?.isDone == true,
                             .calfCircumference: cga.calfCircumference?.isDone == true,
                             .gripStrength: cga.gripStrength?.isDone == true,
                             .sarcopeniaAssessment: cga.sarcopeniaScreening?.isDone == true], forKey: .mobility)

        domains.updateValue([.miniMentalStateExamination: true,
                             .verbalFluencyTest: false,
                             .clockDrawingTest: false,
                             .moca: false,
                             .geriatricDepressionScale: false], forKey: .cognitive)

        domains.updateValue([.visualAcuityAssessment: true, .hearingLossAssessment: false], forKey: .sensory)

        domains.updateValue([.katzScale: true, .lawtonScale: false], forKey: .functional)

        domains.updateValue([.miniNutritionalAssessment: true], forKey: .nutricional)

        domains.updateValue([.apgarScale: true, .zaritScale: true], forKey: .social)

        domains.updateValue([.polypharmacyCriteria: true], forKey: .polypharmacy)

        domains.updateValue([.charlsonIndex: true], forKey: .comorbidity)

        domains.updateValue( [.suspectedAbuse: true, .cardiovascularRiskEstimation: false,
                              .chemotherapyToxicityRisk: false], forKey: .other)
    }

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: .init(domains: domains))
    }
}
