//
//  CalfCircumferenceInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import Foundation

protocol CalfCircumferenceLogic: ActionButtonDelegate, TextFieldDelegate {
    func controllerDidLoad()
}

class CalfCircumferenceInteractor: CalfCircumferenceLogic {

    // MARK: - Private Properties

    private var presenter: CalfCircumferencePresentationLogic?
    private var typedCircumference: Double?

    // MARK: - Init

    init(presenter: CalfCircumferencePresentationLogic) {
        self.presenter = presenter
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        // Not fully implemented
        sendDataToPresenter()
    }

    func didTapActionButton(identifier: String?) {
        guard let typedCircumference else { return }
        presenter?.route(toRoute: .testResults(test: .calfCircumference, results: .init(circumference: typedCircumference)))
    }

    func didChangeText(text: String, identifier: LocalizedTable?) {
        typedCircumference = Double(text.replacingOccurrences(of: ",", with: "."))
        sendDataToPresenter()
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> CalfCircumferenceModels.ControllerViewModel {
        var isResultsButtonEnabled: Bool = false
        let instructions: [CGAModels.Instruction] = [.init(number: 1, description: LocalizedTable.calfCircumferenceInstruction.localized)]

        if let typedCircumference, typedCircumference > 0 {
            isResultsButtonEnabled = true
        } else {
            isResultsButtonEnabled = false
        }

        return CalfCircumferenceModels.ControllerViewModel(instructions: instructions,
                                                           typedCircumference: typedCircumference?.regionFormatted(fractionDigits: 2),
                                                           imageName: "calfCircumference",
                                                           isResultsButtonEnabled: isResultsButtonEnabled)
    }
}
