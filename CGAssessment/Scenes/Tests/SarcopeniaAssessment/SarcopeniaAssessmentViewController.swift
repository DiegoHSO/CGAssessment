//
//  SarcopeniaAssessmentViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.controllerDidLoad()
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
        case .testResults(let test, let results):
            router?.routeToTestResults(test: test, results: results)
        }
    }

    func presentData(viewModel: SarcopeniaAssessmentModels.ControllerViewModel) {
        self.viewModel = viewModel

        tabBarController?.tabBar.isHidden = true
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
        tableView?.register(cellType: SelectableTableViewCell.self)
        tableView?.register(cellType: ActionButtonTableViewCell.self)
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
}

extension SarcopeniaAssessmentViewController: UITableViewDataSource {

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

        let selectedQuestion: SelectableKeys

        switch section {
        case .title:
            selectedQuestion = .none
        case .firstQuestion:
            selectedQuestion = viewModel.firstQuestionOption
        case .secondQuestion:
            selectedQuestion = viewModel.secondQuestionOption
        case .thirdQuestion:
            selectedQuestion = viewModel.thirdQuestionOption
        case .fourthQuestion:
            selectedQuestion = viewModel.fourthQuestionOption
        case .fifthQuestion:
            selectedQuestion = viewModel.fifthQuestionOption
        case .sixthQuestion:
            selectedQuestion = viewModel.sixthQuestionOption
        case .done:
            selectedQuestion = .none
        }

        switch row {
        case .question:
            guard let questionViewModel = viewModel.questions[section] else { return UITableViewCell(frame: .zero) }

            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.className,
                                                           for: indexPath) as? SelectableTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(title: questionViewModel.question, options: questionViewModel.options,
                                        delegate: interactor, selectedQuestion: selectedQuestion,
                                        leadingConstraint: 35, textStyle: .regular))

            return cell
        case .done:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionButtonTableViewCell.className,
                                                           for: indexPath) as? ActionButtonTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.seeResults.localized, backgroundColor: .primary, delegate: interactor)

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
                         backgroundColor: .primary, leadingConstraint: 25)

            return header
        }

        return nil
    }
}
