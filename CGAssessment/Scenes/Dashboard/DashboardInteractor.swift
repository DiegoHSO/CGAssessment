//
//  DashboardInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 17/09/23.
//

import Foundation

protocol DashboardLogic: FeatureComponentDelegate, NoTodoEvaluationDelegate, NoRecentApplicationDelegate {
    func controllerDidLoad()
    func controllerWillDisappear()
    func didSelect(menuOption: DashboardModels.MenuOption)
}

class DashboardInteractor: DashboardLogic {

    // MARK: - Private Properties

    private var presenter: DashboardPresentationLogic?
    private var worker: DashboardWorker?
    private var recentCGA: DashboardModels.LatestCGAViewModel?
    private var todoEvaluations: [DashboardModels.TodoEvaluationViewModel] = []
    private var didRemoteChange = NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange).receive(on: RunLoop.main)

    // MARK: - Init

    init(presenter: DashboardPresentationLogic, worker: DashboardWorker) {
        self.presenter = presenter
        self.worker = worker
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        setupNotification()
        computeViewModelData()
        sendDataToPresenter()
    }

    func controllerWillDisappear() {
        // swiftlint:disable:next notification_center_detachment
        NotificationCenter.default.removeObserver(self)
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
            presenter?.route(toRoute: .cga(cgaId: nil))
        case .evaluation(let id):
            presenter?.route(toRoute: .cga(cgaId: id))
        case .lastCGA:
            presenter?.route(toRoute: .cga(cgaId: recentCGA?.id))
        }
    }

    // MARK: - Private Methods

    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateData),
                                               name: .NSPersistentStoreRemoteChange,
                                               object: nil)
    }

    @objc
    private func updateData() {
        DispatchQueue.main.async {
            self.computeViewModelData()
            self.sendDataToPresenter()
        }
    }

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
              let birthDate = latestCGA.patient?.birthDate, let id = latestCGA.cgaId else { return }

        var missingDomains: Int = 9

        if let isFirstTestDone = latestCGA.timedUpAndGo?.isDone, isFirstTestDone, let isSecondTestDone = latestCGA.walkingSpeed?.isDone,
           isSecondTestDone, let isThirdTestDone = latestCGA.calfCircumference?.isDone, isThirdTestDone,
           let isFourthTestDone = latestCGA.gripStrength?.isDone, isFourthTestDone,
           let isFifthTestDone = latestCGA.sarcopeniaScreening?.isDone, isFifthTestDone {
            missingDomains -= 1
        }

        recentCGA = .init(patientName: patientName, patientAge: birthDate.yearSinceCurrentDate, missingDomains: missingDomains, id: id)
    }

    private func computeTodoEvaluationsData() {
        guard let todoEvaluations = try? worker?.getClosestCGAs() else { return }

        self.todoEvaluations = todoEvaluations.compactMap({ evaluation in
            guard let patientName = evaluation.patient?.name, let birthDate = evaluation.patient?.birthDate,
                  let lastModification = evaluation.lastModification, let id = evaluation.cgaId else { return nil }

            let alteredDomains: Int = 3

            return DashboardModels.TodoEvaluationViewModel(patientName: patientName, patientAge: birthDate.yearSinceCurrentDate,
                                                           alteredDomains: alteredDomains, nextApplicationDate: lastModification.addingMonth(1),
                                                           lastApplicationDate: lastModification, id: id)
        })
    }

}

// MARK: - Internal Delegate extensions

extension DashboardInteractor {
    func didTapComponent(identifier: DashboardModels.MenuOption) {
        switch identifier {
        case .patients:
            presenter?.route(toRoute: .patients)
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

    func didTapToReviewCGAs() {
        didSelect(menuOption: .cgas)
    }

    func didTapToSeeCGAExample() {
        didSelect(menuOption: .cgaDomains)
    }
}
