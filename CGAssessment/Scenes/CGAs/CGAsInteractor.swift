//
//  CGAsInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 01/10/23.
//

import Foundation

protocol CGAsLogic: AnyObject {
    func controllerDidLoad()
    func didSelect(cgaId: UUID?)
}

class CGAsInteractor: CGAsLogic {

    // MARK: - Private Properties

    private var presenter: CGAsPresentationLogic?
    private var worker: CGAsWorker?
    private var patientId: UUID?
    private var selectedFilter: CGAsModels.FilterOptions = .recent
    private var viewModelsByPatient: CGAsModels.CGAsByPatient?
    private var viewModelsByDate: CGAsModels.CGAsByDate?

    // MARK: - Init

    init(presenter: CGAsPresentationLogic, worker: CGAsWorker, patientId: UUID?, cgaId: UUID? = nil) {
        self.presenter = presenter
        self.worker = worker
        self.patientId = patientId
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        computeViewModelData()
        sendDataToPresenter()
    }

    func didSelect(cgaId: UUID?) {
        presenter?.route(toRoute: .cgaDomains(cgaId: cgaId))
    }

    // MARK: - Private Methods

    private func computeViewModelData() {
        switch selectedFilter {
        case .recent, .older:
            guard var cgas = try? worker?.getCGAs(for: patientId) else { return }
            cgas.sort(by: { selectedFilter == .older ? ($0.lastModification ?? Date()) < ($1.lastModification ?? Date())
                        : ($0.lastModification ?? Date()) > ($1.lastModification ?? Date())})

            let viewModels: [CGAsModels.CGAViewModel] = cgas.compactMap { cga in
                var domainsStatus: CGAsModels.DomainsStatus = [:]

                if let timedUpAndGo = cga.timedUpAndGo, let walkingSpeed = cga.walkingSpeed,
                   let calfCircumference = cga.calfCircumference, let gripStrength = cga.gripStrength,
                   let sarcopeniaAssessment = cga.sarcopeniaAssessment {
                    if timedUpAndGo.isDone, walkingSpeed.isDone, calfCircumference.isDone,
                       gripStrength.isDone, sarcopeniaAssessment.isDone {
                        domainsStatus.updateValue(.done, forKey: .mobility)
                    } else {
                        domainsStatus.updateValue(.incomplete, forKey: .mobility)
                    }
                } else if cga.timedUpAndGo == nil, cga.walkingSpeed == nil, cga.calfCircumference == nil,
                          cga.gripStrength == nil, cga.sarcopeniaAssessment == nil {
                    domainsStatus.updateValue(.notStarted, forKey: .mobility)
                } else {
                    domainsStatus.updateValue(.incomplete, forKey: .mobility)
                }

                return .init(patientName: cga.patient?.name, lastEditedDate: cga.lastModification ?? Date(),
                             domainsStatus: domainsStatus, cgaId: cga.cgaId)
            }

            let cgasByDate = Dictionary(grouping: viewModels, by: { CGAsModels.DateFilter(month: $0.lastEditedDate.month, year: $0.lastEditedDate.year) })

            self.viewModelsByDate = cgasByDate
        case .byPatient:
            guard let patients = try? worker?.getPatients() else { return }
            var patientCGAs: [String: [CGA]] = [:]
            var patientCGAsViewModel: CGAsModels.CGAsByPatient = [:]

            patients.forEach { patient in
                guard let name = patient.name, let cgas = patient.cgas?.allObjects as? [CGA] else { return }
                patientCGAs.updateValue(cgas, forKey: name)
            }

            patientCGAs.forEach { (patient, cgas) in
                let viewModels: [CGAsModels.CGAViewModel] = cgas.compactMap { cga in
                    var domainsStatus: CGAsModels.DomainsStatus = [:]

                    if let timedUpAndGo = cga.timedUpAndGo, let walkingSpeed = cga.walkingSpeed,
                       let calfCircumference = cga.calfCircumference, let gripStrength = cga.gripStrength,
                       let sarcopeniaAssessment = cga.sarcopeniaAssessment {
                        if timedUpAndGo.isDone, walkingSpeed.isDone, calfCircumference.isDone,
                           gripStrength.isDone, sarcopeniaAssessment.isDone {
                            domainsStatus.updateValue(.done, forKey: .mobility)
                        } else {
                            domainsStatus.updateValue(.incomplete, forKey: .mobility)
                        }
                    } else if cga.timedUpAndGo == nil, cga.walkingSpeed == nil, cga.calfCircumference == nil,
                              cga.gripStrength == nil, cga.sarcopeniaAssessment == nil {
                        domainsStatus.updateValue(.notStarted, forKey: .mobility)
                    } else {
                        domainsStatus.updateValue(.incomplete, forKey: .mobility)
                    }

                    return .init(patientName: cga.patient?.name, lastEditedDate: cga.lastModification ?? Date(),
                                 domainsStatus: domainsStatus, cgaId: cga.cgaId)
                }

                patientCGAsViewModel.updateValue(viewModels, forKey: patient)
            }

            self.viewModelsByPatient = patientCGAsViewModel
        }
    }

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: .init(viewModelsByPatient: viewModelsByPatient,
                                                viewModelsByDate: viewModelsByDate,
                                                filterOptions: patientId == nil ? [.recent, .older, .byPatient] : [.recent, .older],
                                                selectedFilter: selectedFilter))
    }
}
