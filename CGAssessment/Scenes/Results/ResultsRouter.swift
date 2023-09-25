//
//  ResultsRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import UIKit

protocol ResultsRoutingLogic {
    func routeToNextTest(test: SingleDomainModels.Test)
    func routeBack(domain: CGADomainsModels.Domain)
}

class ResultsRouter: ResultsRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    // swiftlint:disable:next cyclomatic_complexity
    func routeToNextTest(test: SingleDomainModels.Test) {
        switch test {
        case .timedUpAndGo:
            routeToTimedUpAndGoTest()
        case .walkingSpeed:
            routeToWalkingSpeedTest()
        case .calfCircumference:
            break
        case .gripStrength:
            break
        case .sarcopeniaAssessment:
            break
        case .miniMentalStateExamination:
            break
        case .verbalFluencyTest:
            break
        case .clockDrawingTest:
            break
        case .moca:
            break
        case .geriatricDepressionScale:
            break
        case .visualAcuityAssessment:
            break
        case .hearingLossAssessment:
            break
        case .katzScale:
            break
        case .lawtonScale:
            break
        case .miniNutritionalAssessment:
            break
        case .apgarScale:
            break
        case .zaritScale:
            break
        case .polypharmacyCriteria:
            break
        case .charlsonIndex:
            break
        case .suspectedAbuse:
            break
        case .cardiovascularRiskEstimation:
            break
        case .chemotherapyToxicityRisk:
            break
        }
    }

    func routeBack(domain: CGADomainsModels.Domain) {
        guard let singleDomainController = viewController?.navigationController?.viewControllers
                .first(where: { $0 is SingleDomainViewController }) as? SingleDomainViewController else { return }

        let presenter = SingleDomainPresenter(viewController: singleDomainController)
        let interactor = SingleDomainInteractor(presenter: presenter, domain: domain)
        let router = SingleDomainRouter(viewController: singleDomainController)

        singleDomainController.setupArchitecture(interactor: interactor, router: router)

        viewController?.navigationController?.popToViewController(singleDomainController, animated: true)
    }

    // MARK: - Private Methods

    private func routeToTimedUpAndGoTest() {
        let storyboard = UIStoryboard(name: "TimedUpAndGo", bundle: Bundle.main)
        guard let timedUpAndGoController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? TimedUpAndGoViewController else {
            return
        }

        let presenter = TimedUpAndGoPresenter(viewController: timedUpAndGoController)
        let interactor = TimedUpAndGoInteractor(presenter: presenter)
        let router = TimedUpAndGoRouter(viewController: timedUpAndGoController)

        timedUpAndGoController.setupArchitecture(interactor: interactor, router: router)

        viewController?.navigationController?.pushViewController(timedUpAndGoController, animated: true)
    }

    private func routeToWalkingSpeedTest() {
        let storyboard = UIStoryboard(name: "WalkingSpeed", bundle: Bundle.main)
        guard let walkingSpeedController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? WalkingSpeedViewController else {
            return
        }

        let presenter = WalkingSpeedPresenter(viewController: walkingSpeedController)
        let interactor = WalkingSpeedInteractor(presenter: presenter)
        let router = WalkingSpeedRouter(viewController: walkingSpeedController)

        walkingSpeedController.setupArchitecture(interactor: interactor, router: router)

        viewController?.navigationController?.pushViewController(walkingSpeedController, animated: true)
    }
}
