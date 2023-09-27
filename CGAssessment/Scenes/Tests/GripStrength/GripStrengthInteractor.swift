//
//  GripStrengthInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import Foundation

protocol GripStrengthLogic: ActionButtonDelegate, TextFieldDelegate {
    func controllerDidLoad()
}

class GripStrengthInteractor: GripStrengthLogic {

    // MARK: - Private Properties

    private var presenter: GripStrengthPresentationLogic?
    private var typedFirstMeasurement: Double?
    private var typedSecondMeasurement: Double?
    private var typedThirdMeasurement: Double?

    // MARK: - Init

    init(presenter: GripStrengthPresentationLogic) {
        self.presenter = presenter
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        // Not fully implemented
        sendDataToPresenter()
    }

    func didTapActionButton(identifier: String?) {
        guard let typedFirstMeasurement, let typedSecondMeasurement, let typedThirdMeasurement,
              typedFirstMeasurement > 0, typedSecondMeasurement > 0, typedThirdMeasurement > 0 else { return }

        // TODO: Change gender to patient's
        presenter?.route(toRoute: .testResults(test: .gripStrength, results: .init(firstMeasurement: typedFirstMeasurement,
                                                                                   secondMeasurement: typedSecondMeasurement,
                                                                                   thirdMeasurement: typedThirdMeasurement,
                                                                                   gender: Gender.allCases.randomElement() ?? .female)))
    }

    func didChangeText(text: String, identifier: LocalizedTable?) {
        guard let identifier else { return }

        switch identifier {
        case .firstMeasurement:
            typedFirstMeasurement = TimeInterval(text.replacingOccurrences(of: ",", with: "."))
        case .secondMeasurement:
            typedSecondMeasurement = TimeInterval(text.replacingOccurrences(of: ",", with: "."))
        case .thirdMeasurement:
            typedThirdMeasurement = TimeInterval(text.replacingOccurrences(of: ",", with: "."))
        default:
            return
        }

        sendDataToPresenter()
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> GripStrengthModels.ControllerViewModel {
        var isResultsButtonEnabled: Bool = false
        let instructions: [CGAModels.Instruction] = [.init(number: 1, description: LocalizedTable.gripStrengthFirstInstruction.localized),
                                                     .init(number: 2, description: LocalizedTable.gripStrengthSecondInstruction.localized),
                                                     .init(number: 3, description: LocalizedTable.gripStrengthThirdInstruction.localized),
                                                     .init(number: 4, description: LocalizedTable.gripStrengthFourthInstruction.localized),
                                                     .init(number: 5, description: LocalizedTable.gripStrengthFifthInstruction.localized)]

        if let typedFirstMeasurement, let typedSecondMeasurement, let typedThirdMeasurement,
           typedFirstMeasurement > 0, typedSecondMeasurement > 0, typedThirdMeasurement > 0 {
            isResultsButtonEnabled = true
        } else {
            isResultsButtonEnabled = false
        }

        return GripStrengthModels.ControllerViewModel(instructions: instructions,
                                                      typedFirstMeasurement: typedFirstMeasurement?.regionFormatted(fractionDigits: 2),
                                                      typedSecondMeasurement: typedSecondMeasurement?.regionFormatted(fractionDigits: 2),
                                                      typedThirdMeasurement: typedThirdMeasurement?.regionFormatted(fractionDigits: 2),
                                                      imageName: "gripStrength", isResultsButtonEnabled: isResultsButtonEnabled)
    }
}
