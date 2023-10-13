//
//  ResultsRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import UIKit

protocol ResultsRoutingLogic {
    func routeToNextTest(test: SingleDomainModels.Test)
    func routeBack(domain: CGADomainsModels.Domain?)
    func routeToSarcopeniaAssessment()
}

class ResultsRouter: ResultsRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?
    private let cgaId: UUID?

    // MARK: - Init

    init(viewController: UIViewController, cgaId: UUID?) {
        self.viewController = viewController
        self.cgaId = cgaId
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
            routeToCalfCircumferenceTest()
        case .gripStrength:
            routeToGripStrengthTest()
        case .sarcopeniaScreening:
            routeToSarcopeniaScreening()
        case .miniMentalStateExamination:
            routeToMiniMentalStateExam()
        case .verbalFluencyTest:
            routeToVerbalFluencyTest()
        case .clockDrawingTest:
            routeToClockDrawingTest()
        case .moca:
            routeToMoCA()
        case .geriatricDepressionScale:
            routeToGeriatricDepressionScale()
        case .visualAcuityAssessment:
            routeToVisualAcuityAssessment()
        case .hearingLossAssessment:
            routeToHearingLossAssessment()
        case .katzScale:
            routeToKatzScale()
        case .lawtonScale:
            routeToLawtonScale()
        case .miniNutritionalAssessment:
            routeToMiniNutritionalAssessment()
        case .apgarScale:
            routeToApgarScale()
        case .zaritScale:
            routeToZaritScale()
        case .polypharmacyCriteria:
            routeToPolypharmacyCriteria()
        case .charlsonIndex:
            break
        case .suspectedAbuse:
            break
        case .cardiovascularRiskEstimation:
            break
        case .chemotherapyToxicityRisk:
            break
        default:
            break
        }

        if let viewController = viewController, let index = viewController.navigationController?.viewControllers.firstIndex(of: viewController) {
            viewController.navigationController?.viewControllers.remove(atOffsets: IndexSet(index - 1...index))
        }
    }

    func routeBack(domain: CGADomainsModels.Domain?) {
        if domain != nil, let sarcopeniaAssessmentController = viewController?.navigationController?.viewControllers
            .first(where: { $0 is SarcopeniaAssessmentViewController }) as? SarcopeniaAssessmentViewController {

            viewController?.navigationController?.popToViewController(sarcopeniaAssessmentController, animated: true)
            return
        }

        guard let singleDomainController = viewController?.navigationController?.viewControllers
                .first(where: { $0 is SingleDomainViewController }) as? SingleDomainViewController else { return }

        let presenter = SingleDomainPresenter(viewController: singleDomainController)
        let interactor = SingleDomainInteractor(presenter: presenter, domain: domain ?? .mobility, worker: SingleDomainWorker(), cgaId: cgaId)
        let router = SingleDomainRouter(viewController: singleDomainController)

        singleDomainController.setupArchitecture(interactor: interactor, router: router)

        viewController?.navigationController?.popToViewController(singleDomainController, animated: true)
    }

    func routeToSarcopeniaAssessment() {
        guard let sarcopeniaAssessmentController = SarcopeniaAssessmentBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(sarcopeniaAssessmentController, animated: true)

        if let viewController = viewController, let index = viewController.navigationController?.viewControllers.firstIndex(of: viewController) {
            viewController.navigationController?.viewControllers.remove(atOffsets: IndexSet(index - 1...index))
        }
    }

    // MARK: - Private Methods

    private func routeToTimedUpAndGoTest() {
        guard let timedUpAndGoController = TimedUpAndGoBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(timedUpAndGoController, animated: true)
    }

    private func routeToWalkingSpeedTest() {
        guard let walkingSpeedController = WalkingSpeedBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(walkingSpeedController, animated: true)
    }

    private func routeToCalfCircumferenceTest() {
        guard let calfCircumferenceController = CalfCircumferenceBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(calfCircumferenceController, animated: true)
    }

    private func routeToGripStrengthTest() {
        guard let gripStrengthController = GripStrengthBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(gripStrengthController, animated: true)
    }

    private func routeToSarcopeniaScreening() {
        guard let sarcopeniaScreeningController = SarcopeniaScreeningBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(sarcopeniaScreeningController, animated: true)
    }

    private func routeToMiniMentalStateExam() {
        guard let miniMentalStateExamController = MiniMentalStateExamBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(miniMentalStateExamController, animated: true)
    }

    private func routeToVerbalFluencyTest() {
        guard let verbalFluencyController = VerbalFluencyBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(verbalFluencyController, animated: true)
    }

    private func routeToClockDrawingTest() {
        guard let clockDrawingController = ClockDrawingBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(clockDrawingController, animated: true)
    }

    private func routeToMoCA() {
        guard let moCAController = MoCABuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(moCAController, animated: true)
    }

    private func routeToGeriatricDepressionScale() {
        guard let geriatricDepressionScaleController = GeriatricDepressionScaleBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(geriatricDepressionScaleController, animated: true)
    }

    private func routeToVisualAcuityAssessment() {
        guard let visualAcuityAssessmentController = VisualAcuityAssessmentBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(visualAcuityAssessmentController, animated: true)
    }

    private func routeToHearingLossAssessment() {
        guard let hearingLossAssessmentController = HearingLossAssessmentBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(hearingLossAssessmentController, animated: true)
    }

    private func routeToKatzScale() {
        guard let katzScaleController = KatzScaleBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(katzScaleController, animated: true)
    }

    private func routeToLawtonScale() {
        guard let lawtonScaleController = LawtonScaleBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(lawtonScaleController, animated: true)
    }

    private func routeToMiniNutritionalAssessment() {
        guard let miniNutritionalAssessmentController = MiniNutritionalAssessmentBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(miniNutritionalAssessmentController, animated: true)
    }

    private func routeToApgarScale() {
        guard let apgarScaleController = ApgarScaleBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(apgarScaleController, animated: true)
    }

    private func routeToZaritScale() {
        guard let zaritScaleController = ZaritScaleBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(zaritScaleController, animated: true)
    }

    private func routeToPolypharmacyCriteria() {
        guard let polypharmacyCriteriaController = PolypharmacyCriteriaBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(polypharmacyCriteriaController, animated: true)
    }
}
