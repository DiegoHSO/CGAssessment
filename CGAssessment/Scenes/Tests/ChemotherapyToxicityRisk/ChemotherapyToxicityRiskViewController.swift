//
//  ChemotherapyToxicityRiskViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/10/23.
//

import UIKit

protocol ChemotherapyToxicityRiskDisplayLogic: AnyObject {
    func route(toRoute route: ChemotherapyToxicityRiskModels.Routing)
    func presentData(viewModel: ChemotherapyToxicityRiskModels.ControllerViewModel)
}

class ChemotherapyToxicityRiskViewController: UIViewController, ChemotherapyToxicityRiskDisplayLogic {

    // MARK: - Private Properties

    @IBOutlet private weak var tableView: UITableView?

    private typealias Section = ChemotherapyToxicityRiskModels.Section
    private typealias Row = ChemotherapyToxicityRiskModels.Row

    private var viewModel: ChemotherapyToxicityRiskModels.ControllerViewModel?
    private var interactor: ChemotherapyToxicityRiskLogic?
    private var router: ChemotherapyToxicityRiskRoutingLogic?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        interactor?.controllerDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        title = LocalizedTable.chemotherapyToxicityRisk.localized
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        title = LocalizedTable.assessment.localized
    }

    // MARK: - Public Methods

    func setupArchitecture(interactor: ChemotherapyToxicityRiskLogic, router: ChemotherapyToxicityRiskRouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: ChemotherapyToxicityRiskModels.Routing) {
        switch route {
        case .testResults(let test, let results, let cgaId):
            router?.routeToTestResults(test: test, results: results, cgaId: cgaId)
        }
    }

    func presentData(viewModel: ChemotherapyToxicityRiskModels.ControllerViewModel) {
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

        tableView?.accessibilityIdentifier = "ChemotherapyToxicityRiskViewController-tableView"
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension ChemotherapyToxicityRiskViewController: UITableViewDelegate {
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

extension ChemotherapyToxicityRiskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentSection = Section(rawValue: section), let viewModel else { return 0 }

        return viewModel.sections[currentSection]?.count ?? 0
    }

    // swiftlint:disable:next function_body_length cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel, let section = Section(rawValue: indexPath.section),
              let row = viewModel.sections[section]?[safe: indexPath.row] else { return UITableViewCell(frame: .zero) }

        switch row {
        case .question:
            guard let questionViewModel = viewModel.questions[safe: indexPath.row] else { return UITableViewCell(frame: .zero) }

            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.className,
                                                           for: indexPath) as? SelectableTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(title: questionViewModel.question, options: questionViewModel.options,
                                        delegate: interactor, selectedQuestion: questionViewModel.selectedOption,
                                        leadingConstraint: 30, textStyle: .regular,
                                        allowsEditing: questionViewModel.question != .chemotherapyToxicityRiskQuestionEleven))

            cell.accessibilityIdentifier = "ChemotherapyToxicityRiskViewController-SelectableTableViewCell-\(indexPath.section)-\(indexPath.row)"

            return cell
        case .done:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionButtonTableViewCell.className,
                                                           for: indexPath) as? ActionButtonTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.seeResults.localized, backgroundColor: .primary, delegate: interactor)

            cell.accessibilityIdentifier = "ChemotherapyToxicityRiskViewController-ActionButtonTableViewCell"

            return cell
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.keys.count ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let currentSection = Section(rawValue: section) else { return nil }

        if let title = currentSection.title {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView
                                                                            .className) as? TitleHeaderView else {
                return nil
            }

            header.setup(title: title, textSize: 20, backgroundColor: .primary, leadingConstraint: 30)

            return header
        }

        return nil
    }
}
