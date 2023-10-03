//
//  CGAsViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 01/10/23.
//

import UIKit

protocol CGAsDisplayLogic: AnyObject {
    func route(toRoute route: CGAsModels.Routing)
    func presentData(viewModel: CGAsModels.ControllerViewModel)
}

class CGAsViewController: UIViewController, CGAsDisplayLogic {

    // MARK: - Private Properties

    @IBOutlet private weak var tableView: UITableView?

    private var viewModel: CGAsModels.ControllerViewModel?
    private var interactor: CGAsLogic?
    private var router: CGAsRoutingLogic?

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
        tabBarController?.tabBar.isHidden = navigationController?.viewControllers.first != self
    }

    // MARK: - Private Methods

    private func setupViews() {
        title = LocalizedTable.cgas.localized

        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInsetAdjustmentBehavior = .never
        tableView?.sectionHeaderTopPadding = 0

        tableView?.register(headerType: TooltipHeaderView.self)
        tableView?.register(headerType: TitleHeaderView.self)
        tableView?.register(cellType: CGATableViewCell.self)
        tableView?.register(cellType: FilterTableViewCell.self)
    }

    // MARK: - Public Methods

    func setupArchitecture(interactor: CGAsLogic, router: CGAsRouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: CGAsModels.Routing) {
        switch route {
        case .cgaDomains(let cgaId):
            router?.routeToCGA(cgaId: cgaId)
        }
    }

    func presentData(viewModel: CGAsModels.ControllerViewModel) {
        self.viewModel = viewModel

        title = LocalizedTable.cgas.localized

        tabBarController?.tabBar.isHidden = navigationController?.viewControllers.first != self
        tableView?.reloadData()
    }

}

// MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension CGAsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 && viewModel?.patientName == nil ? CGFloat(10) : UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        } else if let viewModelsByDate = viewModel?.viewModelsByDate, let dateSection = viewModel?.dateSections?[safe: indexPath.section - 1],
                  let viewModel = viewModelsByDate[dateSection]?[indexPath.row] {
            interactor?.didSelect(cgaId: viewModel.cgaId)

        } else if let viewModelsByPatient = viewModel?.viewModelsByPatient, let patientSection = viewModel?.patientSections?[safe: indexPath.section - 1],
                  let viewModel = viewModelsByPatient[patientSection]?[indexPath.row] {
            interactor?.didSelect(cgaId: viewModel.cgaId)
        }
    }
}

extension CGAsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if let viewModelsByDate = viewModel?.viewModelsByDate, let dateSection = viewModel?.dateSections?[safe: section - 1] {
            return viewModelsByDate[dateSection]?.count ?? 0
        } else if let viewModelsByPatient = viewModel?.viewModelsByPatient, let patientSection = viewModel?.patientSections?[safe: section - 1] {
            return viewModelsByPatient[patientSection]?.count ?? 0
        }

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellViewModel: CGAsModels.CGAViewModel?

        if indexPath.section == 0 {
            guard let viewModel, let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.className,
                                                                          for: indexPath) as? FilterTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(filterOptions: viewModel.filterOptions, selectedOption: viewModel.selectedFilter, delegate: interactor)

            return cell
        } else if let viewModelsByDate = viewModel?.viewModelsByDate, let dateSection = viewModel?.dateSections?[safe: indexPath.section - 1],
                  let dateViewModel = viewModelsByDate[dateSection]?[indexPath.row] {
            cellViewModel = dateViewModel
        } else if let viewModelsByPatient = viewModel?.viewModelsByPatient, let patientSection = viewModel?.patientSections?[safe: indexPath.section - 1],
                  let patientViewModel = viewModelsByPatient[patientSection]?[indexPath.row] {
            cellViewModel = patientViewModel
        }

        guard let cellViewModel, let cell = tableView.dequeueReusableCell(withIdentifier: CGATableViewCell.className,
                                                                          for: indexPath) as? CGATableViewCell else {
            return UITableViewCell()
        }

        cell.setup(viewModel: cellViewModel)

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return (viewModel?.dateSections?.count ?? viewModel?.patientSections?.count ?? 0) + 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerTitle: String = ""

        if section == 0 {
            guard let patientName = viewModel?.patientName else { return nil }
            headerTitle = LocalizedTable.cgaNameShortened.localized.replacingOccurrences(of: "%PATIENT_NAME", with: patientName)
        } else if let dateSection = viewModel?.dateSections?[safe: section - 1], let month = dateSection.month, let year = dateSection.year {
            let date: Date = .dateFromComponents(month: month, year: year)
            headerTitle = date.monthYearFormatted
        } else if let patientSection = viewModel?.patientSections?[safe: section - 1] {
            headerTitle = patientSection
        }

        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView
                                                                        .className) as? TitleHeaderView else {
            return nil
        }

        header.setup(title: headerTitle)

        return header
    }
}
