//
//  NewCGAViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 17/09/23.
//

import UIKit

protocol NewCGADisplayLogic: AnyObject {
    func route(toRoute route: NewCGAModels.Routing)
    func presentData(viewModel: NewCGAModels.ControllerViewModel)
    func presentAlert()
}

class NewCGAViewController: UIViewController, NewCGADisplayLogic {

    // MARK: - Private Properties

    @IBOutlet private weak var tableView: UITableView?

    private typealias Section = NewCGAModels.Section
    private typealias Row = NewCGAModels.Row

    private var viewModel: NewCGAModels.ControllerViewModel?
    private var interactor: NewCGALogic?
    private var router: NewCGARoutingLogic?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.controllerDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = LocalizedTable.home.localized
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Private Methods

    private func setupViews() {
        title = LocalizedTable.newCga.localized
        tabBarController?.tabBar.isHidden = true

        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInsetAdjustmentBehavior = .never

        tableView?.register(headerType: TitleHeaderView.self)
        tableView?.register(cellType: TitleTableViewCell.self)
        tableView?.register(cellType: ActionButtonTableViewCell.self)
        tableView?.register(cellType: SearchBarTableViewCell.self)
        tableView?.register(cellType: DatePickerTableViewCell.self)
        tableView?.register(cellType: TextFieldTableViewCell.self)
        tableView?.register(cellType: SelectableTableViewCell.self)
        tableView?.register(cellType: ResumedPatientTableViewCell.self)
        tableView?.register(cellType: EmptyStateTableViewCell.self)

        tableView?.accessibilityIdentifier = "NewCGAViewController-tableView"
    }

    // MARK: - Public Methods

    func setupArchitecture(interactor: NewCGALogic, router: NewCGARouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: NewCGAModels.Routing) {
        switch route {
        case .cgaDomains(let patientId):
            router?.routeToCGADomains(patientId: patientId)
        }
    }

    func presentData(viewModel: NewCGAModels.ControllerViewModel) {
        self.viewModel = viewModel

        if viewModel.isSearching {
            tableView?.reloadSections(IndexSet(integer: NewCGAModels.Section.patients.rawValue), with: .fade)
        } else {
            tableView?.reloadData()
        }

        tabBarController?.tabBar.isHidden = true
    }

    func presentAlert() {
        let alert = UIAlertController(title: LocalizedTable.alertTitle.localized,
                                      message: LocalizedTable.alertDescription.localized, preferredStyle: .alert)
        let action = UIAlertAction(title: LocalizedTable.okKey.localized, style: .default) { _ in
            self.interactor?.didSelect(option: .secondOption, value: .yesKey)
        }

        alert.addAction(action)
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension NewCGAViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let currentSection = Section(rawValue: section) else { return .leastNormalMagnitude }
        return currentSection == .newPatient ? UITableView.automaticDimension : .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel, let section = Section(rawValue: indexPath.section) else { return }

        switch section {
        case .patients:
            guard viewModel.patients[safe: indexPath.row] == nil else { return }
            interactor?.didSelect(option: .firstOption, value: .noKey)
        default:
            return
        }
    }
}

extension NewCGAViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentSection = Section(rawValue: section), let viewModel else { return 0 }

        switch currentSection {
        case .newPatient:
            return viewModel.selectedExternalOption == .firstOption ? (viewModel.sections[.newPatient]?.count ?? 0) : 1
        case .existentPatient:
            return viewModel.selectedExternalOption == .secondOption ? (viewModel.sections[.existentPatient]?.count ?? 0) : 1
        case .patients:
            return viewModel.selectedExternalOption == .secondOption ? (viewModel.sections[.patients]?.count ?? 0) : 0
        }
    }

    // swiftlint:disable:next function_body_length cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel, let section = Section(rawValue: indexPath.section) else { return UITableViewCell(frame: .zero) }

        switch viewModel.sections[section]?[safe: indexPath.row] {
        case .noOption:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.className,
                                                           for: indexPath) as? SelectableTableViewCell else {
                return UITableViewCell()
            }

            let viewModel = SelectableModels.OptionsViewModel(title: nil,
                                                              options: [.firstOption: LocalizedTable.noKey],
                                                              delegate: interactor, selectedQuestion: viewModel.selectedExternalOption,
                                                              textStyle: .medium)

            cell.setup(viewModel: viewModel)

            cell.accessibilityIdentifier = "NewCGAViewController-SelectableTableViewCell-NoOption"

            return cell
        case .pleaseFillIn:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.className,
                                                           for: indexPath) as? TitleTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.pleaseFillIn.localized, leadingConstraint: 40)

            cell.accessibilityIdentifier = "NewCGAViewController-TitleTableViewCell"

            return cell
        case .name:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.className,
                                                           for: indexPath) as? TextFieldTableViewCell else {
                return UITableViewCell()
            }

            let viewModel = CGAModels.TextFieldViewModel(title: LocalizedTable.name.localized,
                                                         text: viewModel.patientName,
                                                         placeholder: LocalizedTable.patientName.localized,
                                                         delegate: interactor,
                                                         leadingConstraint: 40)
            cell.setup(viewModel: viewModel)

            cell.accessibilityIdentifier = "NewCGAViewController-TextFieldTableViewCell"

            return cell
        case .gender:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.className,
                                                           for: indexPath) as? SelectableTableViewCell else {
                return UITableViewCell()
            }

            let viewModel = SelectableModels.OptionsViewModel(title: LocalizedTable.gender,
                                                              options: [.firstOption: LocalizedTable.female,
                                                                        .secondOption: LocalizedTable.male],
                                                              delegate: interactor,
                                                              selectedQuestion: viewModel.selectedInternalOption,
                                                              leadingConstraint: 40)

            cell.setup(viewModel: viewModel)

            cell.accessibilityIdentifier = "NewCGAViewController-SelectableTableViewCell-Gender"

            return cell
        case .birthDate:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.className,
                                                           for: indexPath) as? DatePickerTableViewCell else {
                return UITableViewCell()
            }

            let viewModel = CGAModels.DatePickerViewModel(title: LocalizedTable.birthDate.localized,
                                                          date: nil, minimumDate: Date().addingYear(-120),
                                                          maximumDate: Date().addingYear(-40), delegate: interactor,
                                                          leadingConstraint: 40)

            cell.setup(viewModel: viewModel)

            cell.accessibilityIdentifier = "NewCGAViewController-DatePickerTableViewCell"

            return cell
        case .yesOption:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.className,
                                                           for: indexPath) as? SelectableTableViewCell else {
                return UITableViewCell()
            }

            let viewModel = SelectableModels.OptionsViewModel(title: nil,
                                                              options: [.secondOption: LocalizedTable.yesKey],
                                                              delegate: interactor,
                                                              selectedQuestion: viewModel.selectedExternalOption,
                                                              textStyle: .medium)

            cell.setup(viewModel: viewModel)

            cell.accessibilityIdentifier = "NewCGAViewController-SelectableTableViewCell-YesOption"

            return cell
        case .searchBar:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchBarTableViewCell.className,
                                                           for: indexPath) as? SearchBarTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.pleaseSelect.localized,
                       placeholder: LocalizedTable.searchPatient.localized,
                       delegate: interactor)

            cell.accessibilityIdentifier = "NewCGAViewController-SearchBarTableViewCell"

            return cell
        case .patient:
            if let patient = viewModel.patients[safe: indexPath.row] {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ResumedPatientTableViewCell.className,
                                                               for: indexPath) as? ResumedPatientTableViewCell else {
                    return UITableViewCell()
                }

                cell.setup(viewModel: patient, isSelected: viewModel.selectedPatient == patient.id)

                cell.accessibilityIdentifier = "NewCGAViewController-ResumedPatientTableViewCell-\(indexPath.row)"

                return cell
            }

            guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyStateTableViewCell.className,
                                                           for: indexPath) as? EmptyStateTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.newCgaEmptyState.localized,
                       buttonTitle: LocalizedTable.newCgaEmptyStateAction.localized,
                       leadingConstraint: 40)

            cell.accessibilityIdentifier = "NewCGAViewController-EmptyStateTableViewCell"

            return cell
        case .done:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionButtonTableViewCell.className,
                                                           for: indexPath) as? ActionButtonTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.start.localized, backgroundColor: .primary, delegate: interactor)

            cell.accessibilityIdentifier = "NewCGAViewController-ActionButtonTableViewCell"

            return cell
        default:
            return UITableViewCell()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.keys.count ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let currentSection = Section(rawValue: section) else { return nil }

        if currentSection == .newPatient {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView
                                                                            .className) as? TitleHeaderView else {
                return nil
            }

            header.setup(title: LocalizedTable.header.localized,
                         backgroundColor: .primary)

            return header
        }

        return nil
    }
}
