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
    private var selectedPacient: Int = -1
    private var searchText: String = ""
    private var patientName: String = ""
    private var patientBirthDate: Date?
    private var presenter: NewCGAPresentationLogic?
    private var patients: [NewCGAModels.ResumedPatientViewModel] { [NewCGAModels.ResumedPatientViewModel(patient: .init(patientName: "Vanessa Cristina da Silva",
                                                                                                                        patientAge: 52,
                                                                                                                        gender: .female),
                                                                                                         id: 10, // TODO: CoreData ID
                                                                                                         delegate: self,
                                                                                                         isSelected: selectedPacient == 10,
                                                                                                         leadingConstraint: 40),
                                                                    NewCGAModels.ResumedPatientViewModel(patient: .init(patientName: "Danilo de Souza Pinto",
                                                                                                                        patientAge: 30,
                                                                                                                        gender: .male),
                                                                                                         id: 11, // TODO: CoreData ID
                                                                                                         delegate: self,
                                                                                                         isSelected: selectedPacient == 11,
                                                                                                         leadingConstraint: 40),
                                                                    NewCGAModels.ResumedPatientViewModel(patient: .init(patientName: "Jorge Luis Alves de Oliveira",
                                                                                                                        patientAge: 62,
                                                                                                                        gender: .male),
                                                                                                         id: 12, // TODO: CoreData ID
                                                                                                         delegate: self,
                                                                                                         isSelected: selectedPacient == 12,
                                                                                                         leadingConstraint: 40),
                                                                    NewCGAModels.ResumedPatientViewModel(patient: .init(patientName: "Diego Henrique Silva Oliveira",
                                                                                                                        patientAge: 22,
                                                                                                                        gender: .male),
                                                                                                         id: 13, // TODO: CoreData ID
                                                                                                         delegate: self,
                                                                                                         isSelected: selectedPacient == 13,
                                                                                                         leadingConstraint: 40)]
    }

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
            return selectedPacient != -1
        }

        return false
    }

    let externalOptions: Options = [.firstOption: .noKey, .secondOption: .yesKey]
    let internalOption: LocalizedTable = .gender

    // MARK: - Init

    init(presenter: NewCGAPresentationLogic) {
        self.presenter = presenter
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        // Not fully implemented
        sendDataToPresenter()
    }

    // MARK: - Private Methods

    private func sendDataToPresenter(isSearching: Bool = false) {
        presenter?.presentData(viewModel: createViewModel(isSearching: isSearching))
    }

    private func createViewModel(isSearching: Bool = false) -> NewCGAModels.ControllerViewModel {
        return NewCGAModels.ControllerViewModel(patients: filteredPatients,
                                                selectedInternalOption: selectedInternalOption,
                                                selectedExternalOption: selectedExternalOption,
                                                patientName: patientName,
                                                selectedPatient: selectedPacient,
                                                isDone: isDoneEnabled, isSearching: isSearching)
    }
}

// MARK: - Internal Delegate extension

extension NewCGAInteractor: SelectableViewDelegate, SearchBarDelegate,
                            TextFieldDelegate, DatePickerDelegate,
                            ResumedPatientDelegate, ActionButtonDelegate {

    func didTapActionButton(identifier: String?) {
        presenter?.route(toRoute: .cgaDomains)
    }

    func didSelect(patientId: Int) {
        selectedPacient = patientId
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
