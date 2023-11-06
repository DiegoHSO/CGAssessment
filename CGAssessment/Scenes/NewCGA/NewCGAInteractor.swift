//
//  NewCGAInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 17/09/23.
//

import Foundation

protocol NewCGALogic: SelectableViewDelegate, SearchBarDelegate,
                      TextFieldDelegate, DatePickerDelegate,
                      ResumedPatientDelegate, ActionButtonDelegate {
    func controllerDidLoad()
}

class NewCGAInteractor: NewCGALogic {

    // MARK: - Private Properties

    private var selectedInternalOption: SelectableKeys = .none
    private var selectedExternalOption: SelectableKeys = .secondOption
    private var selectedPatient: UUID?
    private var searchText: String = ""
    private var patientName: String = ""
    private var patientBirthDate: Date?
    private var presenter: NewCGAPresentationLogic?
    private var worker: NewCGAWorker?
    private var patients: [NewCGAModels.ResumedPatientViewModel] = []

    private var filteredPatients: [NewCGAModels.ResumedPatientViewModel] {
        if !searchText.isEmpty {
            return patients.filter { $0.patient.patientName.containsCaseInsensitive(searchText)}
        }

        return patients
    }

    private var isDoneEnabled: Bool {
        if selectedExternalOption == .firstOption {
            return !patientName.isEmpty && patientBirthDate != nil && selectedInternalOption != .none
        } else if selectedExternalOption == .secondOption {
            return selectedPatient != nil
        }

        return false
    }

    private let externalOptions: Options = [.firstOption: .noKey, .secondOption: .yesKey]
    private let internalOption: LocalizedTable = .gender

    // MARK: - Init

    init(presenter: NewCGAPresentationLogic, worker: NewCGAWorker) {
        self.presenter = presenter
        self.worker = worker
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        computeViewModelData()
        sendDataToPresenter()
    }

    // MARK: - Private Methods

    private func computeViewModelData() {
        guard let patients = try? worker?.getAllPatients() else { return }

        self.patients = patients.compactMap({ patient in
            guard let birthDate = patient.birthDate, let name = patient.name,
                  let gender = Gender(rawValue: patient.gender), let id = patient.patientId
            else { return nil }

            return .init(patient: .init(patientName: name, patientAge: birthDate.yearSinceCurrentDate, gender: gender),
                         id: id, delegate: self)
        })

        selectedExternalOption = self.patients.isEmpty ? .firstOption : .secondOption
    }

    private func sendDataToPresenter(isSearching: Bool = false) {
        presenter?.presentData(viewModel: createViewModel(isSearching: isSearching))
    }

    private func createViewModel(isSearching: Bool = false) -> NewCGAModels.ControllerViewModel {
        return NewCGAModels.ControllerViewModel(patients: filteredPatients,
                                                selectedInternalOption: selectedInternalOption,
                                                selectedExternalOption: selectedExternalOption,
                                                patientName: patientName,
                                                selectedPatient: selectedPatient,
                                                isDone: isDoneEnabled, isSearching: isSearching)
    }
}

// MARK: - Internal Delegate extension

extension NewCGAInteractor: SelectableViewDelegate, SearchBarDelegate,
                            TextFieldDelegate, DatePickerDelegate,
                            ResumedPatientDelegate, ActionButtonDelegate {

    func didTapActionButton(identifier: String?) {
        switch selectedExternalOption {
        case .firstOption:
            guard !patientName.isEmpty, let worker, let patientBirthDate, selectedInternalOption != .none else { return }
            let gender: Gender = selectedInternalOption == .firstOption ? .female : .male

            do {
                let patientId = try worker.savePatient(patientData: .init(patientName: patientName,
                                                                          birthDate: patientBirthDate, gender: gender))
                presenter?.route(toRoute: .cgaDomains(patientId: patientId))
            } catch {
                presenter?.presentAlert()
            }
        case .secondOption:
            guard let selectedPatient else { return }
            presenter?.route(toRoute: .cgaDomains(patientId: selectedPatient))
        default:
            return
        }
    }

    func didSelect(patientId: UUID) {
        selectedPatient = patientId
        sendDataToPresenter()
    }

    func didChange(searchText: String) {
        self.searchText = searchText
        sendDataToPresenter(isSearching: true)
    }

    func didChangeText(text: String, identifier: LocalizedTable?) {
        patientName = text
        sendDataToPresenter()
    }

    func didSelectDate(date: Date) {
        patientBirthDate = date
        sendDataToPresenter()
    }

    func didSelect(option: SelectableKeys, value: LocalizedTable) {
        if externalOptions.values.contains(where: { $0 == value }) {
            selectedExternalOption = option
        } else if internalOption == value {
            selectedInternalOption = option
        }

        sendDataToPresenter()
    }
}
