//
//  SingleDomainRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 23/09/23.
//

import UIKit

protocol SingleDomainRoutingLogic {
    func routeToSingleTest(test: SingleDomainModels.Test, cgaId: UUID?)
}

class SingleDomainRouter: SingleDomainRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    // swiftlint:disable:next cyclomatic_complexity
    func routeToSingleTest(test: SingleDomainModels.Test, cgaId: UUID?) {
        switch test {
        case .timedUpAndGo:
            routeToTimedUpAndGoTest(cgaId: cgaId)
        case .walkingSpeed:
            routeToWalkingSpeedTest(cgaId: cgaId)
        case .calfCircumference:
            routeToCalfCircumferenceTest(cgaId: cgaId)
        case .gripStrength:
            routeToGripStrengthTest(cgaId: cgaId)
        case .sarcopeniaScreening:
            routeToSarcopeniaAssessment(cgaId: cgaId)
        case .miniMentalStateExamination:
            routeToMiniMentalStateExam(cgaId: cgaId)
        case .verbalFluencyTest:
            routeToVerbalFluencyTest(cgaId: cgaId)
        case .clockDrawingTest:
            routeToClockDrawingTest(cgaId: cgaId)
        case .moca:
            routeToMoCA(cgaId: cgaId)
        case .geriatricDepressionScale:
            routeToGeriatricDepressionScale(cgaId: cgaId)
        case .visualAcuityAssessment:
            routeToVisualAcuityAssessment(cgaId: cgaId)
        case .hearingLossAssessment:
            routeToHearingLossAssessment(cgaId: cgaId)
        case .katzScale:
            routeToKatzScale(cgaId: cgaId)
        case .lawtonScale:
            routeToLawtonScale(cgaId: cgaId)
        case .miniNutritionalAssessment:
            routeToMiniNutritionalAssessment(cgaId: cgaId)
        case .apgarScale:
            routeToApgarScale(cgaId: cgaId)
        case .zaritScale:
            routeToZaritScale(cgaId: cgaId)
        case .polypharmacyCriteria:
            routeToPolypharmacyCriteria(cgaId: cgaId)
        case .charlsonIndex:
            routeToCharlsonIndex(cgaId: cgaId)
        case .suspectedAbuse:
            routeToSuspectedAbuse(cgaId: cgaId)
        case .cardiovascularRiskEstimation:
            break
        case .chemotherapyToxicityRisk:
            routeToChemotherapyToxicityRisk(cgaId: cgaId)
        default:
            break
        }
    }

    // MARK: - Private Methods

    private func routeToTimedUpAndGoTest(cgaId: UUID?) {
        guard let timedUpAndGoController = TimedUpAndGoBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(timedUpAndGoController, animated: true)
    }

    private func routeToWalkingSpeedTest(cgaId: UUID?) {
        guard let walkingSpeedController = WalkingSpeedBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(walkingSpeedController, animated: true)
    }

    private func routeToCalfCircumferenceTest(cgaId: UUID?) {
        guard let calfCircumferenceController = CalfCircumferenceBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(calfCircumferenceController, animated: true)
    }

    private func routeToGripStrengthTest(cgaId: UUID?) {
        guard let gripStrengthController = GripStrengthBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(gripStrengthController, animated: true)
    }

    private func routeToSarcopeniaAssessment(cgaId: UUID?) {
        guard let sarcopeniaAssessmentController = SarcopeniaScreeningBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(sarcopeniaAssessmentController, animated: true)
    }

    private func routeToMiniMentalStateExam(cgaId: UUID?) {
        guard let miniMentalStateExamController = MiniMentalStateExamBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(miniMentalStateExamController, animated: true)
    }

    private func routeToVerbalFluencyTest(cgaId: UUID?) {
        guard let verbalFluencyController = VerbalFluencyBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(verbalFluencyController, animated: true)
    }

    private func routeToClockDrawingTest(cgaId: UUID?) {
        guard let clockDrawingController = ClockDrawingBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(clockDrawingController, animated: true)
    }

    private func routeToMoCA(cgaId: UUID?) {
        guard let moCAController = MoCABuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(moCAController, animated: true)
    }

    private func routeToGeriatricDepressionScale(cgaId: UUID?) {
        guard let geriatricDepressionScaleController = GeriatricDepressionScaleBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(geriatricDepressionScaleController, animated: true)
    }

    private func routeToVisualAcuityAssessment(cgaId: UUID?) {
        guard let visualAcuityAssessmentController = VisualAcuityAssessmentBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(visualAcuityAssessmentController, animated: true)
    }

    private func routeToHearingLossAssessment(cgaId: UUID?) {
        guard let hearingLossAssessmentController = HearingLossAssessmentBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(hearingLossAssessmentController, animated: true)
    }

    private func routeToKatzScale(cgaId: UUID?) {
        guard let katzScaleController = KatzScaleBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(katzScaleController, animated: true)
    }

    private func routeToLawtonScale(cgaId: UUID?) {
        guard let lawtonScaleController = LawtonScaleBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(lawtonScaleController, animated: true)
    }

    private func routeToMiniNutritionalAssessment(cgaId: UUID?) {
        guard let miniNutritionalAssessmentController = MiniNutritionalAssessmentBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(miniNutritionalAssessmentController, animated: true)
    }

    private func routeToApgarScale(cgaId: UUID?) {
        guard let apgarScaleController = ApgarScaleBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(apgarScaleController, animated: true)
    }

    private func routeToZaritScale(cgaId: UUID?) {
        guard let zaritScaleController = ZaritScaleBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(zaritScaleController, animated: true)
    }

    private func routeToPolypharmacyCriteria(cgaId: UUID?) {
        guard let polypharmacyCriteriaController = PolypharmacyCriteriaBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(polypharmacyCriteriaController, animated: true)
    }

    private func routeToCharlsonIndex(cgaId: UUID?) {
        guard let charlsonIndexController = CharlsonIndexBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(charlsonIndexController, animated: true)
    }

    private func routeToSuspectedAbuse(cgaId: UUID?) {
        guard let suspectedAbuseController = SuspectedAbuseBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(suspectedAbuseController, animated: true)
    }

    private func routeToChemotherapyToxicityRisk(cgaId: UUID?) {
        guard let chemotherapyToxicityRiskController = ChemotherapyToxicityRiskBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(chemotherapyToxicityRiskController, animated: true)
    }
}
