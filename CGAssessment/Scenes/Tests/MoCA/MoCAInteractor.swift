//
//  MoCAInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import Foundation
import OSLog
import PhotosUI

protocol MoCALogic: ActionButtonDelegate, BinaryOptionDelegate, StepperDelegate, SelectableViewDelegate, GroupedButtonDelegate {
    func controllerDidLoad()
    func didCaptureImage(image: UIImage?)
}

class MoCAInteractor: MoCALogic {

    // MARK: - Private Properties

    private var presenter: MoCAPresentationLogic?
    private var worker: MoCAWorker?
    private var cgaId: UUID?
    private var countedWords: Int16 = 0
    private var selectedOption: SelectableKeys = .secondOption
    private var selectedCirclesImage: UIImage?
    private var selectedWatchImage: UIImage?
    private var isWatchImageLastSelected: Bool = false
    private var rawBinaryQuestions: MoCAModels.RawBinaryQuestions =  [
        .visuospatial: [1: .none, 2: .none, 3: .none, 4: .none, 5: .none],
        .naming: [1: .none, 2: .none, 3: .none],
        .mocaFourthSectionSecondInstruction: [1: .none, 2: .none],
        .mocaFourthSectionThirdInstruction: [1: .none],
        .mocaFourthSectionFourthInstruction: [1: .none, 2: .none, 3: .none, 4: .none, 5: .none],
        .language: [1: .none, 2: .none],
        .abstraction: [1: .none, 2: .none],
        .delayedRecall: [1: .none, 2: .none, 3: .none, 4: .none, 5: .none],
        .orientation: [1: .none, 2: .none, 3: .none, 4: .none, 5: .none, 6: .none]
    ]
    private var circlesImageProgress: Progress?
    private var watchImageProgress: Progress?
    private var selection = [String: PHPickerResult]()
    private var selectedAssetIdentifiers = [String]()
    private var selectedAssetIdentifierIterator: IndexingIterator<[String]>?
    private var currentAssetIdentifier: String?

    // MARK: - Init

    init(presenter: MoCAPresentationLogic, worker: MoCAWorker, cgaId: UUID?) {
        self.presenter = presenter
        self.worker = worker
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        computeViewModelData()
        sendDataToPresenter()
    }

    func didTapActionButton(identifier: String?) {
        handleNavigation(updatesDatabase: true)
    }

    func didSelect(option: SelectableBinaryKeys, numberIdentifier: Int16, sectionIdentifier: LocalizedTable) {
        rawBinaryQuestions[sectionIdentifier]?.updateValue(option, forKey: numberIdentifier)
        updateDatabase()
        sendDataToPresenter()
    }

    func didSelect(option: SelectableKeys, value: LocalizedTable) {
        selectedOption = option
        updateDatabase()
        sendDataToPresenter()
    }

    func didChangeValue(value: Int) {
        countedWords = Int16(value)
        updateDatabase()
    }

    func didSelect(buttonIdentifier: LocalizedTable) {
        switch buttonIdentifier {
        case .gallery:
            presentPicker()
        case .takePhoto:
            presentCamera()
        default:
            return
        }
    }

    func didCaptureImage(image: UIImage?) {
        if let compressedImage = image?.jpeg(.medium), let newImage = UIImage(data: compressedImage) {
            if selectedCirclesImage == nil {
                selectedCirclesImage = newImage
            } else if selectedWatchImage == nil {
                selectedWatchImage = newImage
            } else {
                isWatchImageLastSelected.toggle()
                selectedCirclesImage = isWatchImageLastSelected ? newImage : selectedCirclesImage
                selectedWatchImage = isWatchImageLastSelected ? selectedWatchImage : newImage
            }
        }

        updateDatabase()
        sendDataToPresenter()
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> MoCAModels.ControllerViewModel {
        let question: MoCAModels.QuestionViewModel = .init(question: .miniMentalStateExamFirstQuestion, selectedOption: selectedOption,
                                                           options: [.firstOption: .moreThanTwelveYears,
                                                                     .secondOption: .lessThanTwelveYears])

        let groupedButtons: [CGAModels.GroupedButtonViewModel] = [.init(title: .gallery, symbolName: "photo", delegate: self),
                                                                  .init(title: .takePhoto, symbolName: "camera.fill", delegate: self)]

        let firstBinarySectionQuestions: [Int16: LocalizedTable] = [1: .mocaFirstSectionFirstQuestion,
                                                                    2: .mocaFirstSectionSecondQuestion,
                                                                    3: .mocaFirstSectionThirdQuestion,
                                                                    4: .mocaFirstSectionFourthQuestion,
                                                                    5: .mocaFirstSectionFifthQuestion]

        let secondBinarySectionQuestions: [Int16: LocalizedTable] = [1: .mocaSecondSectionFirstQuestion,
                                                                     2: .mocaSecondSectionSecondQuestion,
                                                                     3: .mocaSecondSectionThirdQuestion]

        let thirdBinarySectionQuestions: [Int16: LocalizedTable] = [1: .mocaThirdSectionFirstQuestion,
                                                                    2: .mocaThirdSectionSecondQuestion]

        let fourthBinarySectionQuestions: [Int16: LocalizedTable] = [1: .mocaFourthSectionFirstQuestion]

        let fifthBinarySectionQuestions: [Int16: LocalizedTable] = [1: .mocaFifthSectionFirstQuestion,
                                                                    2: .mocaFifthSectionSecondQuestion,
                                                                    3: .mocaFifthSectionThirdQuestion,
                                                                    4: .mocaFifthSectionFourthQuestion,
                                                                    5: .mocaFifthSectionFifthQuestion]

        let sixthBinarySectionQuestions: [Int16: LocalizedTable] = [1: .mocaSixthSectionFirstQuestion,
                                                                    2: .mocaSixthSectionSecondQuestion]

        let seventhBinarySectionQuestions: [Int16: LocalizedTable] = [1: .mocaSeventhSectionFirstQuestion,
                                                                      2: .mocaSeventhSectionSecondQuestion]

        let eighthBinarySectionQuestions: [Int16: LocalizedTable] = [1: .mocaEighthSectionFirstQuestion,
                                                                     2: .mocaEighthSectionSecondQuestion,
                                                                     3: .mocaEighthSectionThirdQuestion,
                                                                     4: .mocaEighthSectionFourthQuestion,
                                                                     5: .mocaEighthSectionFifthQuestion]

        let ninthBinarySectionQuestions: [Int16: LocalizedTable] = [1: .mocaNinthSectionFirstQuestion,
                                                                    2: .mocaNinthSectionSecondQuestion,
                                                                    3: .mocaNinthSectionThirdQuestion,
                                                                    4: .mocaNinthSectionFourthQuestion,
                                                                    5: .mocaNinthSectionFifthQuestion,
                                                                    6: .mocaNinthSectionSixthQuestion]

        let binaryQuestions: MoCAModels.BinaryQuestions = [.visuospatial:
                                                            [4: .init(title: .mocaFirstSectionThirdInstruction,
                                                                      sectionIdentifier: .visuospatial,
                                                                      options: rawBinaryQuestions[.visuospatial] ?? [:],
                                                                      questions: firstBinarySectionQuestions, firstOptionTitle: LocalizedTable.yesKey.localized,
                                                                      secondOptionTitle: LocalizedTable.noKey.localized, delegate: self, bottomConstraint: 30)],
                                                           .naming:
                                                            [4: .init(title: nil, sectionIdentifier: .naming, options: rawBinaryQuestions[.naming] ?? [:],
                                                                      questions: secondBinarySectionQuestions, firstOptionTitle: LocalizedTable.yesKey.localized,
                                                                      secondOptionTitle: LocalizedTable.noKey.localized, delegate: self, bottomConstraint: 30)],
                                                           .attention:
                                                            [4: .init(title: nil, sectionIdentifier: .mocaFourthSectionSecondInstruction, options: rawBinaryQuestions[.mocaFourthSectionSecondInstruction] ?? [:],
                                                                      questions: thirdBinarySectionQuestions, firstOptionTitle: LocalizedTable.yesKey.localized,
                                                                      secondOptionTitle: LocalizedTable.noKey.localized, delegate: self, bottomConstraint: 30),
                                                             7: .init(title: nil, sectionIdentifier: .mocaFourthSectionThirdInstruction, options: rawBinaryQuestions[.mocaFourthSectionThirdInstruction] ?? [:],
                                                                      questions: fourthBinarySectionQuestions, firstOptionTitle: LocalizedTable.yesKey.localized,
                                                                      secondOptionTitle: LocalizedTable.noKey.localized, delegate: self, bottomConstraint: 30),
                                                             8: .init(title: .mocaFourthSectionFourthInstruction, sectionIdentifier: .mocaFourthSectionFourthInstruction, options: rawBinaryQuestions[.mocaFourthSectionFourthInstruction] ?? [:],
                                                                      questions: fifthBinarySectionQuestions, firstOptionTitle: LocalizedTable.yesKey.localized,
                                                                      secondOptionTitle: LocalizedTable.noKey.localized, delegate: self, bottomConstraint: 30)],
                                                           .language: [3: .init(title: nil, sectionIdentifier: .language, options: rawBinaryQuestions[.language] ?? [:],
                                                                                questions: sixthBinarySectionQuestions, firstOptionTitle: LocalizedTable.yesKey.localized,
                                                                                secondOptionTitle: LocalizedTable.noKey.localized, delegate: self, bottomConstraint: 30)],
                                                           .abstraction: [0: .init(title: .mocaSixthSectionFirstInstruction, sectionIdentifier: .abstraction, options: rawBinaryQuestions[.abstraction] ?? [:],
                                                                                   questions: seventhBinarySectionQuestions, firstOptionTitle: LocalizedTable.yesKey.localized,
                                                                                   secondOptionTitle: LocalizedTable.noKey.localized, delegate: self, bottomConstraint: 30)],
                                                           .delayedRecall: [2: .init(title: nil, sectionIdentifier: .delayedRecall, options: rawBinaryQuestions[.delayedRecall] ?? [:],
                                                                                     questions: eighthBinarySectionQuestions, firstOptionTitle: LocalizedTable.yesKey.localized,
                                                                                     secondOptionTitle: LocalizedTable.noKey.localized, delegate: self, bottomConstraint: 30)],
                                                           .orientation: [0: .init(title: .mocaEighthSectionFirstInstruction, sectionIdentifier: .orientation, options: rawBinaryQuestions[.orientation] ?? [:],
                                                                                   questions: ninthBinarySectionQuestions, firstOptionTitle: LocalizedTable.yesKey.localized,
                                                                                   secondOptionTitle: LocalizedTable.noKey.localized, delegate: self, bottomConstraint: 30)]
        ]

        let binaryOptionsDictionaries = rawBinaryQuestions.map { $0.value }
        let selectedBinaryOptions = binaryOptionsDictionaries.reduce([]) { partialResult, dictionary in
            partialResult + dictionary.map { $0.value }
        }

        let isResultsButtonEnabled: Bool = selectedBinaryOptions.allSatisfy({ $0 != .none }) && selectedOption != .none

        return .init(question: question, countedWords: countedWords, selectedOption: selectedOption,
                     binaryQuestions: binaryQuestions, circlesImage: selectedCirclesImage,
                     watchImage: selectedWatchImage, groupedButtons: groupedButtons,
                     circlesProgress: circlesImageProgress, watchProgress: watchImageProgress,
                     isResultsButtonEnabled: isResultsButtonEnabled)
    }

    private func handleNavigation(updatesDatabase: Bool = false) {
        if updatesDatabase {
            updateDatabase(isDone: true)
        }

        let binaryOptionsDictionaries = rawBinaryQuestions.map { $0.value }
        let selectedBinaryOptions = binaryOptionsDictionaries.reduce([]) { partialResult, dictionary in
            partialResult + dictionary.map { $0.value }
        }

        let isAllDone: Bool = selectedBinaryOptions.allSatisfy({ $0 != .none })

        if isAllDone {
            presenter?.route(toRoute: .testResults(test: .moca, results: .init(binaryQuestions: rawBinaryQuestions, selectedEducationOption: selectedOption, countedWords: countedWords), cgaId: cgaId))
        }
    }

    private func computeViewModelData() {
        if let mocaProgress = try? worker?.getMoCAProgress() {
            guard let binaryOptions = mocaProgress.binaryOptions?.allObjects as? [BinaryOption] else {
                return
            }

            binaryOptions.forEach { option in
                guard let selectedOption = SelectableBinaryKeys(rawValue: option.selectedOption),
                      let identifier = LocalizedTable(rawValue: option.sectionId ?? "") else { return }
                rawBinaryQuestions[identifier]?.updateValue(selectedOption, forKey: option.optionId)
            }

            selectedCirclesImage = UIImage(data: mocaProgress.circlesImage ?? Data())
            selectedWatchImage = UIImage(data: mocaProgress.watchImage ?? Data())
            countedWords = mocaProgress.countedWords
            selectedOption = SelectableKeys(rawValue: mocaProgress.selectedOption) ?? .none

            if mocaProgress.isDone {
                handleNavigation()
            }
        }
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateMoCAProgress(with: .init(binaryQuestions: rawBinaryQuestions, selectedEducationOption: selectedOption, countedWords: countedWords,
                                                       circlesImage: selectedCirclesImage?.jpeg(.highest), watchImage: selectedWatchImage?.jpeg(.highest), isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }

    private func handleImageSelection() {
        guard let assetIdentifier = selectedAssetIdentifierIterator?.next() else { return }
        currentAssetIdentifier = assetIdentifier

        guard let itemProvider = selection[assetIdentifier]?.itemProvider else { return }

        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            circlesImageProgress = itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                DispatchQueue.main.async {
                    guard let compressedImage = (image as? UIImage)?.jpeg(.medium) else { return }
                    self?.selectedCirclesImage = UIImage(data: compressedImage)
                    self?.sendDataToPresenter()
                    self?.updateDatabase()
                }
            }
        } else {
            circlesImageProgress = nil
        }

        guard let assetIdentifier = selectedAssetIdentifierIterator?.next() else { return }
        currentAssetIdentifier = assetIdentifier

        guard let itemProvider = selection[assetIdentifier]?.itemProvider else { return }

        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            watchImageProgress = itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                DispatchQueue.main.async {
                    guard let compressedImage = (image as? UIImage)?.jpeg(.medium) else { return }
                    self?.selectedWatchImage = UIImage(data: compressedImage)
                    self?.sendDataToPresenter()
                    self?.updateDatabase()
                }
            }
        } else {
            watchImageProgress = nil
        }

        sendDataToPresenter()
    }

    private func presentPicker() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())

        // Set the filter type according to the user’s selection.
        configuration.filter = .images
        // Set the mode to avoid transcoding, if possible, if your app supports arbitrary image/video encodings.
        configuration.preferredAssetRepresentationMode = .current
        // Set the selection behavior to respect the user’s selection order.
        configuration.selection = .ordered
        // Set the selection limit to enable multiselection.
        configuration.selectionLimit = 2
        // Set the preselected asset identifiers with the identifiers that the app tracks.
        configuration.preselectedAssetIdentifiers = selectedAssetIdentifiers

        presenter?.route(toRoute: .imagePicker(configuration: configuration, delegate: self))
    }

    private func presentCamera() {
        presenter?.route(toRoute: .camera)
    }
}

extension MoCAInteractor: PHPickerViewControllerDelegate {
    /// Parse ImagePicker results
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        presenter?.dismissPresentingController()

        let existingSelection = self.selection
        var newSelection = [String: PHPickerResult]()
        for result in results {
            let identifier = result.assetIdentifier!
            newSelection[identifier] = existingSelection[identifier] ?? result
        }

        // Track the selection in case the user deselects it later.
        selection = newSelection
        selectedAssetIdentifiers = results.map(\.assetIdentifier!)
        selectedAssetIdentifierIterator = selectedAssetIdentifiers.makeIterator()

        handleImageSelection()
    }
}
