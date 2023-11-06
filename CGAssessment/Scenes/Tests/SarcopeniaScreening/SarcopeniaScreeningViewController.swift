//
//  SarcopeniaScreeningViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import UIKit

protocol SarcopeniaScreeningDisplayLogic: AnyObject {
    func route(toRoute route: SarcopeniaScreeningModels.Routing)
    func presentData(viewModel: SarcopeniaScreeningModels.ControllerViewModel)
}

class SarcopeniaScreeningViewController: UIViewController, SarcopeniaScreeningDisplayLogic {

    @IBOutlet private weak var tableView: UITableView?

    private typealias Section = SarcopeniaScreeningModels.Section
    private typealias Row = SarcopeniaScreeningModels.Row

    private var viewModel: SarcopeniaScreeningModels.ControllerViewModel?
    private var interactor: SarcopeniaScreeningLogic?
    private var router: SarcopeniaScreeningRoutingLogic?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        interactor?.controllerDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        title = LocalizedTable.sarcopeniaAssessment.localized
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        title = LocalizedTable.assessment.localized
    }

    // MARK: - Public Methods

    func setupArchitecture(interactor: SarcopeniaScreeningLogic, router: SarcopeniaScreeningRouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: SarcopeniaScreeningModels.Routing) {
        switch route {
        case .testResults(let test, let results, let cgaId):
            router?.routeToTestResults(test: test, results: results, cgaId: cgaId)
        }
    }

    func presentData(viewModel: SarcopeniaScreeningModels.ControllerViewModel) {
        self.viewModel = viewModel

        tableView?.reloadData()
    }

    // MARK: - Private Methods

    private func setupViews() {
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true

        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInsetAdjustmentBehavior = .never

        tableView?.register(headerType: TitleHeaderView.self)
        tableView?.register(cellType: SelectableTableViewCell.self)
        tableView?.register(cellType: ActionButtonTableViewCell.self)

        tableView?.accessibilityIdentifier = "SarcopeniaScreeningViewController-tableView"
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension SarcopeniaScreeningViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let currentSection = Section(rawValue: section) else { return .leastNormalMagnitude }
        return currentSection == .done ? .leastNormalMagnitude : UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

extension SarcopeniaScreeningViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentSection = Section(rawValue: section), let viewModel else { return 0 }

        switch currentSection {
        case .title:
            return viewModel.sections[.title]?.count ?? 0
        case .firstQuestion:
            return viewModel.sections[.firstQuestion]?.count ?? 0
        case .secondQuestion:
            return viewModel.sections[.secondQuestion]?.count ?? 0
        case .thirdQuestion:
            return viewModel.sections[.thirdQuestion]?.count ?? 0
        case .fourthQuestion:
            return viewModel.sections[.fourthQuestion]?.count ?? 0
        case .fifthQuestion:
            return viewModel.sections[.fifthQuestion]?.count ?? 0
        case .sixthQuestion:
            return viewModel.sections[.sixthQuestion]?.count ?? 0
        case .done:
            return viewModel.sections[.done]?.count ?? 0
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel, let section = Section(rawValue: indexPath.section),
              let row = viewModel.sections[section]?[safe: indexPath.row] else { return UITableViewCell(frame: .zero) }

        switch row {
        case .question:
            guard let questionViewModel = viewModel.questions[section] else { return UITableViewCell(frame: .zero) }

            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.className,
                                                           for: indexPath) as? SelectableTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(title: questionViewModel.question, options: questionViewModel.options,
                                        delegate: interactor, selectedQuestion: questionViewModel.selectedOption,
                                        leadingConstraint: 35, textStyle: .regular))

            cell.accessibilityIdentifier = "SarcopeniaScreeningViewController-SelectableTableViewCell-\(indexPath.section)-\(indexPath.row)"

            return cell
        case .done:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionButtonTableViewCell.className,
                                                           for: indexPath) as? ActionButtonTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.seeResults.localized, backgroundColor: .primary, delegate: interactor)

            cell.accessibilityIdentifier = "SarcopeniaScreeningViewController-ActionButtonTableViewCell"

            return cell
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.keys.count ?? 0
    }

    // swiftlint:disable:next cyclomatic_complexity
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let currentSection = Section(rawValue: section) else { return nil }

        if currentSection != .done {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView
                                                                            .className) as? TitleHeaderView else {
                return nil
            }

            let headerTitle: String

            switch currentSection {
            case .title:
                headerTitle = LocalizedTable.sarcfScreening.localized
            case .firstQuestion:
                headerTitle = LocalizedTable.strength.localized
            case .secondQuestion:
                headerTitle = LocalizedTable.helpToWalk.localized
            case .thirdQuestion:
                headerTitle = LocalizedTable.getUpFromBed.localized
            case .fourthQuestion:
                headerTitle = LocalizedTable.climbStairs.localized
            case .fifthQuestion:
                headerTitle = LocalizedTable.falls.localized
            case .sixthQuestion:
                headerTitle = LocalizedTable.calf.localized
            case .done:
                headerTitle = ""
            }

            header.setup(title: headerTitle, textSize: currentSection == .title ? 20 : 18,
                         backgroundColor: .primary, leadingConstraint: 25,
                         bottomConstraint: currentSection == .title ? 0 : 20)

            return header
        }

        return nil
    }
}
