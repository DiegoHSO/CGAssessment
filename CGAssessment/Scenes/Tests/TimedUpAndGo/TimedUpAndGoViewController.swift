//
//  TimedUpAndGoViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import UIKit

protocol TimedUpAndGoDisplayLogic: AnyObject {
    func route(toRoute route: TimedUpAndGoModels.Routing)
    func presentData(viewModel: TimedUpAndGoModels.ControllerViewModel)
}

class TimedUpAndGoViewController: UIViewController, TimedUpAndGoDisplayLogic {

    // MARK: - Private Properties

    @IBOutlet private weak var tableView: UITableView?

    private typealias Section = TimedUpAndGoModels.Section
    private typealias Row = TimedUpAndGoModels.Row

    private var viewModel: TimedUpAndGoModels.ControllerViewModel?
    private var interactor: TimedUpAndGoLogic?
    private var router: TimedUpAndGoRoutingLogic?

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
    }

    // MARK: - Public Methods

    func setupArchitecture(interactor: TimedUpAndGoLogic, router: TimedUpAndGoRouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: TimedUpAndGoModels.Routing) {
        switch route {
        case .testResults(let test, let results):
            router?.routeToTestResults(test: test, results: results)
        }
    }

    func presentData(viewModel: TimedUpAndGoModels.ControllerViewModel) {
        self.viewModel = viewModel

        tabBarController?.tabBar.isHidden = true
        tableView?.reloadData()
    }

    // MARK: - Private Methods

    private func setupViews() {
        title = LocalizedTable.timedUpAndGo.localized

        //  UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true

        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInsetAdjustmentBehavior = .never

        tableView?.register(headerType: TitleHeaderView.self)
        tableView?.register(cellType: InstructionsTableViewCell.self)
        tableView?.register(cellType: SelectableTableViewCell.self)
        tableView?.register(cellType: TextFieldTableViewCell.self)
        tableView?.register(cellType: StopwatchTableViewCell.self)
        tableView?.register(cellType: ActionButtonTableViewCell.self)
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension TimedUpAndGoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let currentSection = Section(rawValue: section) else { return .leastNormalMagnitude }
        return currentSection == .done || currentSection == .appStopwatch ? .leastNormalMagnitude : UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

extension TimedUpAndGoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentSection = Section(rawValue: section), let viewModel else { return 0 }

        switch currentSection {
        case .instructions:
            return viewModel.sections[.instructions]?.count ?? 0
        case .manualStopwatch:
            return viewModel.selectedOption == .firstOption ? (viewModel.sections[.manualStopwatch]?.count ?? 0) : 1
        case .appStopwatch:
            return viewModel.selectedOption == .secondOption ? (viewModel.sections[.appStopwatch]?.count ?? 0) : 1
        case .done:
            return viewModel.isResultsButtonEnabled ?
                (viewModel.sections[.done]?.count ?? 0) : 0
        }
    }

    // swiftlint:disable:next function_body_length cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel, let section = Section(rawValue: indexPath.section) else { return UITableViewCell(frame: .zero) }

        switch viewModel.sections[section]?[safe: indexPath.row] {
        case .instructions:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: InstructionsTableViewCell.className,
                                                           for: indexPath) as? InstructionsTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(instructions: viewModel.instructions))

            return cell
        case .hasStopwatch:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.className,
                                                           for: indexPath) as? SelectableTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(title: nil, options: [.firstOption: LocalizedTable.hasStopwatch],
                                        delegate: interactor, selectedQuestion: viewModel.selectedOption,
                                        textStyle: .medium))

            return cell
        case .doesNotHaveStopwatch:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.className,
                                                           for: indexPath) as? SelectableTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(title: nil, options: [.secondOption: LocalizedTable.doesNotHaveStopwatch],
                                        delegate: interactor, selectedQuestion: viewModel.selectedOption,
                                        textStyle: .medium))

            return cell
        case .textFieldStopwatch:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.className,
                                                           for: indexPath) as? TextFieldTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(title: nil, text: viewModel.typedElapsedTime,
                                        placeholder: LocalizedTable.timeTakenSeconds.localized,
                                        delegate: interactor, keyboardType: .decimalPad))

            return cell
        case .stopwatch:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StopwatchTableViewCell.className,
                                                           for: indexPath) as? StopwatchTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(delegate: interactor)

            return cell
        case .done:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionButtonTableViewCell.className,
                                                           for: indexPath) as? ActionButtonTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.seeResults.localized, backgroundColor: .primary, delegate: interactor)

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

        if currentSection == .instructions || currentSection == .manualStopwatch {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView
                                                                            .className) as? TitleHeaderView else {
                return nil
            }

            header.setup(title: currentSection == .instructions ? LocalizedTable.instructions.localized
                            : LocalizedTable.stopwatch.localized, backgroundColor: .primary,
                         leadingConstraint: 25)

            return header
        }

        return nil
    }
}
