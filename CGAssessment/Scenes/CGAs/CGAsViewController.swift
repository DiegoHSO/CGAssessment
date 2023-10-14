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
    func presentDeletionAlert(for indexPath: IndexPath)
    func presentErrorDeletingAlert()
}

class CGAsViewController: UIViewController, CGAsDisplayLogic, StatusViewProtocol {

    // MARK: - Private Properties

    @IBOutlet internal weak var tableView: UITableView?
    internal var isSelected: Bool = false
    internal var statusViewModel: CGAModels.StatusViewModel? { nil }

    private var viewModel: CGAsModels.ControllerViewModel?
    private var interactor: CGAsLogic?
    private var router: CGAsRoutingLogic?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBarButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.controllerDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor?.controllerWillDisappear()
        tabBarController?.tabBar.isHidden = navigationController?.viewControllers.first != self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let headerView = tableView?.tableHeaderView else { return }
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableView?.tableHeaderView = headerView
            tableView?.layoutIfNeeded()
        }
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
        tableView?.register(headerType: CGAsSubtitleHeaderView.self)
        tableView?.register(cellType: EmptyStateTableViewCell.self)
        tableView?.register(cellType: CGATableViewCell.self)
        tableView?.register(cellType: FilterTableViewCell.self)
    }

    private func setupBarButtonItem() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"),
                                        style: .plain, target: self,
                                        action: #selector(infoButtonTapped))
        self.navigationItem.rightBarButtonItem = barButton
    }

    @objc private func infoButtonTapped() {
        isSelected.toggle()
        tableView?.tableHeaderView = currentHeader
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: isSelected ? "info.circle.fill" : "info.circle")
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
        case .newCGA:
            router?.routeToNewCGA()
        }
    }

    func presentData(viewModel: CGAsModels.ControllerViewModel) {
        self.viewModel = viewModel

        title = LocalizedTable.cgas.localized

        tabBarController?.tabBar.isHidden = navigationController?.viewControllers.first != self
        tableView?.reloadData()
    }

    func presentDeletionAlert(for indexPath: IndexPath) {
        let alert = UIAlertController(title: LocalizedTable.deleteCGAQuestion.localized,
                                      message: LocalizedTable.deleteCGADescription.localized, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: LocalizedTable.deleteCGA.localized, style: .destructive) { _ in
            if let viewModelsByDate = self.viewModel?.viewModelsByDate,
               let dateSection = self.viewModel?.dateSections?[safe: indexPath.section - 1],
               let viewModel = viewModelsByDate[dateSection]?[indexPath.row] {
                self.viewModel?.viewModelsByDate?[dateSection]?.remove(at: indexPath.row)
                self.interactor?.didConfirmDeletion(for: viewModel.cgaId)
            } else if let viewModelsByPatient = self.viewModel?.viewModelsByPatient,
                      let patientSection = self.viewModel?.patientSections?[safe: indexPath.section - 1],
                      let viewModel = viewModelsByPatient[patientSection]?[indexPath.row] {
                self.viewModel?.viewModelsByPatient?[patientSection]?.remove(at: indexPath.row)
                self.interactor?.didConfirmDeletion(for: viewModel.cgaId)
            }

            self.tableView?.deleteRows(at: [indexPath], with: .fade)
        }

        let cancelAction = UIAlertAction(title: LocalizedTable.cancel.localized, style: .cancel)

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    func presentErrorDeletingAlert() {
        let alert = UIAlertController(title: LocalizedTable.cgaDeletionErrorTitle.localized,
                                      message: LocalizedTable.cgaDeletionErrorDescription.localized, preferredStyle: .alert)

        let okAction = UIAlertAction(title: LocalizedTable.okKey.localized, style: .default)

        alert.addAction(okAction)
        present(alert, animated: true)
    }

}

// MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension CGAsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0, viewModel?.patientName == nil { return CGFloat(10) }
        if viewModel?.viewModelsByDate == nil, viewModel?.viewModelsByPatient == nil { return CGFloat(20) }
        return UITableView.automaticDimension
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
        } else {
            interactor?.didTapToStartNewCGA()
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 0 {
            return .none
        } else if let viewModelsByDate = viewModel?.viewModelsByDate, let dateSection = viewModel?.dateSections?[safe: indexPath.section - 1],
                  viewModelsByDate[dateSection]?[indexPath.row] != nil {
            return .delete
        } else if let viewModelsByPatient = viewModel?.viewModelsByPatient, let patientSection = viewModel?.patientSections?[safe: indexPath.section - 1],
                  viewModelsByPatient[patientSection]?[indexPath.row] != nil {
            return .delete
        } else {
            return .none
        }
    }
}

extension CGAsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            interactor?.didSwipeToDelete(indexPath: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if let viewModelsByDate = viewModel?.viewModelsByDate, let dateSection = viewModel?.dateSections?[safe: section - 1] {
            return viewModelsByDate[dateSection]?.count ?? 0
        } else if let viewModelsByPatient = viewModel?.viewModelsByPatient, let patientSection = viewModel?.patientSections?[safe: section - 1] {
            return viewModelsByPatient[patientSection]?.count ?? 0
        }

        return 1
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
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyStateTableViewCell.className,
                                                           for: indexPath) as? EmptyStateTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.cgasEmptyState.localized,
                       buttonTitle: LocalizedTable.cgasEmptyStateAction.localized)

            return cell
        }

        guard let cellViewModel, let cell = tableView.dequeueReusableCell(withIdentifier: CGATableViewCell.className,
                                                                          for: indexPath) as? CGATableViewCell else {
            return UITableViewCell()
        }

        cell.setup(viewModel: cellViewModel)

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return (viewModel?.dateSections?.count ?? viewModel?.patientSections?.count ?? 1) + 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerTitle: String = ""

        if section == 0 {
            guard let patientName = viewModel?.patientName else { return nil }
            headerTitle = LocalizedTable.cgaNameShortened.localized.replacingOccurrences(of: "%PATIENT_NAME", with: patientName)
        } else if let dateSection = viewModel?.dateSections?[safe: section - 1], let month = dateSection.month, let year = dateSection.year {
            let date: Date = .dateFromComponents(month: month, year: year)
            headerTitle = date.monthYearFormatted.capitalizingFirstLetter()
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
