//
//  MoCAModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import UIKit
import PhotosUI

struct MoCAModels {

    typealias CentralTexts = [Section: [Int: LocalizedTable]]
    typealias Images = [Section: [Int: UIImage?]]
    typealias Questions = [Section: QuestionViewModel]
    typealias BinaryQuestions = [Section: [Int: BinaryOptionsViewModel?]]
    typealias RawBinaryQuestions = [LocalizedTable: [Int16: SelectableBinaryKeys]]
    typealias BinaryOptionsViewModel = BinaryOptionsModels.BinaryOptionsViewModel
    typealias Instructions = [Section: [Int: LocalizedTable?]]

    struct ControllerViewModel {
        let question: QuestionViewModel
        let countedWords: Int16
        let selectedOption: SelectableKeys
        let binaryQuestions: BinaryQuestions
        let circlesImage: UIImage?
        let watchImage: UIImage?
        let groupedButtons: [CGAModels.GroupedButtonViewModel]
        let circlesProgress: Progress?
        let watchProgress: Progress?
        let isResultsButtonEnabled: Bool

        var images: Images {
            guard let circlesAppImage = UIImage(named: "moca-1"), let cubeAppImage = UIImage(named: "moca-2"),
                  let lionImage = UIImage(named: "moca-3"), let rhinoImage = UIImage(named: "moca-4"),
                  let camelImage = UIImage(named: "moca-5") else { return [:] }

            return [.visuospatial: [1: circlesAppImage, 3: cubeAppImage],
                    .naming: [1: lionImage, 2: rhinoImage, 3: camelImage]]
        }

        var instructions: Instructions {
            return [.visuospatial: [0: .mocaFirstSectionFirstInstruction, 1: nil, 2: .mocaFirstSectionSecondInstruction, 5: .mocaFirstSectionFourthInstruction],
                    .naming: [0: .mocaSecondSectionFirstInstruction],
                    .memory: [0: .mocaThirdSectionFirstInstruction],
                    .attention: [0: .mocaFourthSectionFirstInstruction, 1: nil, 2: .mocaFourthSectionSecondInstruction,
                                 3: nil, 4: nil, 5: .mocaFourthSectionThirdInstruction, 6: nil, 7: nil, 8: .mocaFourthSectionThirdInstruction],
                    .language: [0: .mocaFifthSectionFirstInstruction], .delayedRecall: [0: .mocaSeventhSectionFirstInstruction]
            ]
        }

        var centralTexts: CentralTexts {
            return [.memory: [1: .firstCentralItem], .attention: [1: .secondCentralItem, 3: .thirdCentralItem, 6: .fourthCentralItem], .language: [1: .fifthCentralItem, 2: .sixthCentralItem], .delayedRecall: [1: .firstCentralItem]]
        }

        var sections: [Section: [Row]] {
            let optionsForDoneSection: [Row] = isResultsButtonEnabled ? [.done] : []

            var sections: [Section: [Row]] =  [.visuospatial: [.instruction, .image, .instruction, .image, .binaryQuestion, .instruction, .selectionButtons],
                                               .naming: [.instruction, .image, .image, .image, .binaryQuestion],
                                               .memory: [.instruction, .centralText],
                                               .attention: [.instruction, .centralText, .instruction, .centralText, .binaryQuestion,
                                                            .instruction, .centralText, .binaryQuestion, .binaryQuestion],
                                               .language: [.instruction, .centralText, .centralText, .binaryQuestion, .stepper],
                                               .abstraction: [.binaryQuestion], .delayedRecall: [.instruction, .centralText, .binaryQuestion],
                                               .orientation: [.binaryQuestion], .education: [.question], .done: optionsForDoneSection]

            if watchImage != nil || watchProgress != nil {
                sections[.visuospatial]?.append(.watchImage)
            }

            if circlesImage != nil || circlesProgress != nil {
                sections[.visuospatial]?.append(.circlesImage)
            }

            return sections
        }
    }

    struct QuestionViewModel {
        let question: LocalizedTable?
        let selectedOption: SelectableKeys
        let options: Options
    }

    struct TestResults {
        let binaryQuestions: RawBinaryQuestions
        let selectedEducationOption: SelectableKeys
        let countedWords: Int16
    }

    struct TestData {
        let binaryQuestions: RawBinaryQuestions
        let selectedEducationOption: SelectableKeys
        let countedWords: Int16
        let circlesImage: Data?
        let watchImage: Data?
        let isDone: Bool
    }

    enum Routing {
        case testResults(test: SingleDomainModels.Test, results: TestResults, cgaId: UUID?)
        case imagePicker(configuration: PHPickerConfiguration, delegate: PHPickerViewControllerDelegate?)
        case camera
    }

    enum Section: Int {
        case visuospatial
        case naming
        case memory
        case attention
        case language
        case abstraction
        case delayedRecall
        case orientation
        case education
        case done
    }

    enum Row {
        case instruction
        case image
        case circlesImage
        case watchImage
        case binaryQuestion
        case selectionButtons
        case centralText
        case stepper
        case question
        case done
    }

}
