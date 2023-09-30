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
    private var worker: DashboardWorker?
    private var recentCGA: DashboardModels.LatestCGAViewModel?
    private var todoEvaluations: [DashboardModels.TodoEvaluationViewModel] = []

    // MARK: - Init

    init(presenter: DashboardPresentationLogic, worker: DashboardWorker) {
        self.presenter = presenter
        self.worker = worker
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        computeViewModelData()
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
        return DashboardModels.ViewModel(latestEvaluation: recentCGA, todoEvaluations: todoEvaluations)
    }

    private func computeViewModelData() {
        computeLatestCGAData()
        computeTodoEvaluationsData()
    }

    private func computeLatestCGAData() {
        guard let latestCGA = try? worker?.getLatestCGA(), let patientName = latestCGA.patient?.name,
              let birthDate = latestCGA.patient?.birthDate else { return }

        var missingDomains: Int = 9

        if let isFirstTestDone = latestCGA.timedUpAndGo?.isDone, isFirstTestDone, let isSecondTestDone = latestCGA.walkingSpeed?.isDone,
           isSecondTestDone, let isThirdTestDone = latestCGA.calfCircumference?.isDone, isThirdTestDone,
           let isFourthTestDone = latestCGA.gripStrength?.isDone, isFourthTestDone,
           let isFifthTestDone = latestCGA.sarcopeniaScreening?.isDone, isFifthTestDone {
            missingDomains -= 1
        }

        recentCGA = .init(patientName: patientName, patientAge: birthDate.yearSinceCurrentDate, missingDomains: missingDomains)
    }

    private func computeTodoEvaluationsData() {
        guard let todoEvaluations = try? worker?.getClosestCGAs() else { return }

        self.todoEvaluations = todoEvaluations.compactMap({ evaluation in
            guard let patientName = evaluation.patient?.name, let birthDate = evaluation.patient?.birthDate,
                  let lastModification = evaluation.lastModification else { return nil }

            let alteredDomains: Int = 5

            return DashboardModels.TodoEvaluationViewModel(patientName: patientName, patientAge: birthDate.yearSinceCurrentDate,
                                                           alteredDomains: alteredDomains, nextApplicationDate: lastModification.addingMonth(1),
                                                           lastApplicationDate: lastModification)
        })
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
