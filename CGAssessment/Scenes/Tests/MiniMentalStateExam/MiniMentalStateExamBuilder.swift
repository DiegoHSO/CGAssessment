//
//  MiniMentalStateExamBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 05/10/23.
//

import UIKit

class MiniMentalStateExamBuilder {

    static func build(cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "MiniMentalStateExam", bundle: Bundle.main)
        guard let miniMentalStateExamController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? MiniMentalStateExamViewController else {
            return nil
        }

        let presenter = MiniMentalStateExamPresenter(viewController: miniMentalStateExamController)
        let interactor = MiniMentalStateExamInteractor(presenter: presenter, worker: MiniMentalStateExamWorker(cgaId: cgaId), cgaId: cgaId)
        let router = MiniMentalStateExamRouter(viewController: miniMentalStateExamController)

        miniMentalStateExamController.setupArchitecture(interactor: interactor, router: router)

        return miniMentalStateExamController
    }

}
