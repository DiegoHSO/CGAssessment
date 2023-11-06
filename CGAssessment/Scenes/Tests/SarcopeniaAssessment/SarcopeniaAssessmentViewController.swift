//
//  SarcopeniaAssessmentViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 28/09/23.
//

import UIKit

protocol SarcopeniaAssessmentDisplayLogic: AnyObject {
    func route(toRoute route: SarcopeniaAssessmentModels.Routing)
    func presentData(viewModel: SarcopeniaAssessmentModels.ControllerViewModel)
}

class SarcopeniaAssessmentViewController: UIViewController, SarcopeniaAssessmentDisplayLogic {

    @IBOutlet private weak var tableView: UITableView?

    private typealias Section = SarcopeniaAssessmentModels.Section
    private typealias Row = SarcopeniaAssessmentModels.Row

    private var viewModel: SarcopeniaAssessmentModels.ControllerViewModel?
    private var interactor: SarcopeniaAssessmentLogic?
    private var router: SarcopeniaAssessmentRoutingLogic?

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
        tabBarController?.tabBar.isHidden = false
        title = LocalizedTable.assessment.localized
    }

    // MARK: - Public Methods

    func setupArchitecture(interactor: SarcopeniaAssessmentLogic, router: SarcopeniaAssessmentRouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: SarcopeniaAssessmentModels.Routing) {
        switch route {
        case .gripStrength(let cgaId):
            router?.routeToGripStrengthTest(cgaId: cgaId)
        case .calfCircumference(let cgaId):
            router?.routeToCalfCircumferenceTest(cgaId: cgaId)
        case .timedUpAndGo(let cgaId):
            router?.routeToTimedUpAndGoTest(cgaId: cgaId)
        case .walkingSpeed(let cgaId):
            router?.routeToWalkingSpeedTest(cgaId: cgaId)
        case .testResults(let test, let results, let cgaId):
            router?.routeToTestResults(test: test, results: results, cgaId: cgaId)
        }
    }

    func presentData(viewModel: SarcopeniaAssessmentModels.ControllerViewModel) {
        self.viewModel = viewModel

        tableView?.reloadData()
    }

    // MARK: - Private Methods

    private func setupViews() {
        title = LocalizedTable.sarcopeniaAssessment.localized

        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true

        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInsetAdjustmentBehavior = .never

        tableView?.register(headerType: TitleHeaderView.self)
        tableView?.register(headerType: TooltipHeaderView.self)
        tableView?.register(cellType: TitleTableViewCell.self)
        tableView?.register(cellType: TestTableViewCell.self)
        tableView?.register(cellType: ActionButtonTableViewCell.self)

        tableView?.accessibilityIdentifier = "SarcopeniaAssessmentViewController-tableView"
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension SarcopeniaAssessmentViewController: UITableViewDelegate {
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentSection = Section(rawValue: indexPath.section),
              let test = viewModel?.tests[currentSection]?[indexPath.row] else { return }
        interactor?.didSelect(test: test)
    }
}

extension SarcopeniaAssessmentViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentSection = Section(rawValue: section), let viewModel else { return 0 }

        return viewModel.sections[currentSection]?.count ?? 0
    }

    // swiftlint:disable:next cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel, let section = Section(rawValue: indexPath.section),
              let row = viewModel.sections[section]?[safe: indexPath.row] else { return UITableViewCell(frame: .zero) }

        switch row {
        case .title:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.className,
                                                           for: indexPath) as? TitleTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.muscleHealth.localized, bottomConstraint: 0, fontSize: 21)

            cell.accessibilityIdentifier = "SarcopeniaAssessmentViewController-Title"

            return cell
        case .test:
            guard let test = viewModel.tests[section]?[indexPath.row],
                  let status = viewModel.testsCompletionStatus[test] else { return UITableViewCell() }

            guard let cell = tableView.dequeueReusableCell(withIdentifier: TestTableViewCell.className,
                                                           for: indexPath) as? TestTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(test: test, status: status))

            if let isEnabled = viewModel.enabledCategories[section], isEnabled {
                cell.setEnabledState()
            } else {
                cell.setDisabledState()
            }

            cell.accessibilityIdentifier = "SarcopeniaAssessmentViewController-TestTableViewCell-\(indexPath.section)-\(indexPath.row)"

            return cell
        case .done:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionButtonTableViewCell.className,
                                                           for: indexPath) as? ActionButtonTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.seeResults.localized, backgroundColor: .primary, delegate: interactor)

            cell.accessibilityIdentifier = "SarcopeniaAssessmentViewController-ActionButtonTableViewCell"

            return cell
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.keys.count ?? 0
    }

    // swiftlint:disable:next cyclomatic_complexity
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let currentSection = Section(rawValue: section) else { return nil }

        switch currentSection {
        case .title:
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TooltipHeaderView
                                                                            .className) as? TooltipHeaderView else {
                return nil
            }

            header.setup(text: LocalizedTable.sarcopeniaTooltip.localized)

            return header
        case .strength, .quantity, .performance:
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView
                                                                            .className) as? TitleHeaderView else {
                return nil
            }

            let headerTitle: String

            switch currentSection {
            case .strength:
                headerTitle = LocalizedTable.strength.localized
            case .quantity:
                headerTitle = LocalizedTable.quantity.localized
            case .performance:
                headerTitle = LocalizedTable.performance.localized
            default:
                headerTitle = ""
            }

            if let isEnabled = viewModel?.enabledCategories[currentSection], isEnabled {
                header.setEnabledState()
            } else {
                header.setDisabledState()
            }

            header.setup(title: headerTitle, textSize: 18, backgroundColor: .primary)

            return header
        case .done:
            return nil
        }

    }
}
