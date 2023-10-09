//
//  MoCARouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import UIKit
import PhotosUI

protocol MoCARoutingLogic {
    func routeToTestResults(test: SingleDomainModels.Test, results: MoCAModels.TestResults, cgaId: UUID?)
    func routeToImagePicker(configuration: PHPickerConfiguration, delegate: PHPickerViewControllerDelegate?)
    func routeToUserCamera(delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?)
    func dismissPresentingController()
}

class MoCARouter: MoCARoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToTestResults(test: SingleDomainModels.Test, results: MoCAModels.TestResults, cgaId: UUID?) {
        guard let resultsController = ResultsBuilder.build(test: test, results: results, cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(resultsController, animated: true)
    }

    func routeToImagePicker(configuration: PHPickerConfiguration, delegate: PHPickerViewControllerDelegate?) {
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = delegate

        viewController?.present(picker, animated: true)
    }

    func routeToUserCamera(delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = delegate
        viewController?.present(picker, animated: true)
    }

    func dismissPresentingController() {
        viewController?.dismiss(animated: true)
    }
}
