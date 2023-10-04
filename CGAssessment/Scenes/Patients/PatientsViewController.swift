//
//  PatientsViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 03/10/23.
//

import UIKit

protocol PatientsDisplayLogic: AnyObject {
    func route(toRoute route: PatientsModels.Routing)
    func presentData(viewModel: PatientsModels.ControllerViewModel)
}

class PatientsViewController: UIViewController, PatientsDisplayLogic {

    @IBOutlet private weak var tableView: UITableView?

    private typealias Section = PatientsModels.Section
    private typealias Row = PatientsModels.Row

    private var viewModel: PatientsModels.ControllerViewModel?
    private var interactor: PatientsLogic?
    private var router: PatientsRoutingLogic?

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
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Private Methods

    private func setupViews() {
        title = LocalizedTable.patients.localized
        tabBarController?.tabBar.isHidden = true

        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInsetAdjustmentBehavior = .never
        tableView?.sectionHeaderTopPadding = 0

        tableView?.register(headerType: TitleHeaderView.self)
        tableView?.register(cellType: PatientTableViewCell.self)
        tableView?.register(cellType: SearchBarTableViewCell.self)
        tableView?.register(cellType: FilterTableViewCell.self)
        tableView?.register(cellType: EmptyStateTableViewCell.self)
    }

    // MARK: - Public Methods

    func setupArchitecture(interactor: PatientsLogic, router: PatientsRouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: PatientsModels.Routing) {
        switch route {
        case .cgas(let patientId):
            router?.routeToCGAs(patientId: patientId)
        case .newCGA:
            router?.routeToNewCGA()
        }
    }

    func presentData(viewModel: PatientsModels.ControllerViewModel) {
        self.viewModel = viewModel

        if viewModel.isSearching {
            tableView?.reloadSections(IndexSet(integer: PatientsModels.Section.patients.rawValue), with: .fade)
        } else {
            tableView?.reloadData()
        }

        tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension PatientsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let currentSection = Section(rawValue: section) else { return .leastNormalMagnitude }
        return currentSection == .searchAndFilter ? .leastNormalMagnitude : UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel, let section = Section(rawValue: indexPath.section) else { return }

        switch section {
        case .patients:
            if let patientId = viewModel.patients[safe: indexPath.row]?.patientId {
                interactor?.didSelect(patientId: patientId)
            } else {
                interactor?.didTapToStartNewCGA()
            }
        default:
            return
        }
    }
}

extension PatientsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentSection = Section(rawValue: section), let viewModel else { return 0 }
        return viewModel.sections[currentSection]?.count ?? 0
    }

    // swiftlint:disable:next function_body_length cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel, let section = Section(rawValue: indexPath.section) else { return UITableViewCell(frame: .zero) }

        switch viewModel.sections[section]?[safe: indexPath.row] {
        case .searchBar:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchBarTableViewCell.className,
                                                           for: indexPath) as? SearchBarTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: nil, placeholder: LocalizedTable.searchPatient.localized, leadingConstraint: 12, trailingConstraint: 12, delegate: interactor)

            return cell
        case .filter:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.className,
                                                           for: indexPath) as? FilterTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(filterOptions: viewModel.filterOptions, selectedOption: viewModel.selectedFilter, delegate: interactor)

            return cell
        case .patient:
            if let patient = viewModel.patients[safe: indexPath.row] {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PatientTableViewCell.className,
                                                               for: indexPath) as? PatientTableViewCell else {
                    return UITableViewCell()
                }

                cell.setup(viewModel: patient)

                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyStateTableViewCell.className,
                                                               for: indexPath) as? EmptyStateTableViewCell else {
                    return UITableViewCell()
                }

                cell.setup(title: LocalizedTable.newCgaEmptyState.localized,
                           buttonTitle: LocalizedTable.newCgaEmptyStateAction.localized)

                return cell
            }
        default:
            return UITableViewCell()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.keys.count ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let currentSection = Section(rawValue: section) else { return nil }
        return nil
    }
}
