//
//  VerbalFluencyViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import UIKit

protocol VerbalFluencyDisplayLogic: AnyObject {
    func route(toRoute route: VerbalFluencyModels.Routing)
    func presentData(viewModel: VerbalFluencyModels.ControllerViewModel)
}

class VerbalFluencyViewController: UIViewController, VerbalFluencyDisplayLogic {

    // MARK: - Private Properties

    @IBOutlet private weak var tableView: UITableView?

    private typealias Section = VerbalFluencyModels.Section
    private typealias Row = VerbalFluencyModels.Row

    private var viewModel: VerbalFluencyModels.ControllerViewModel?
    private var interactor: VerbalFluencyLogic?
    private var router: VerbalFluencyRoutingLogic?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        interactor?.controllerDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        title = LocalizedTable.verbalFluencyTest.localized
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        title = LocalizedTable.assessment.localized
    }

    // MARK: - Public Methods

    func setupArchitecture(interactor: VerbalFluencyLogic, router: VerbalFluencyRouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: VerbalFluencyModels.Routing) {
        switch route {
        case .testResults(let test, let results, let cgaId):
            router?.routeToTestResults(test: test, results: results, cgaId: cgaId)
        }
    }

    func presentData(viewModel: VerbalFluencyModels.ControllerViewModel) {
        self.viewModel = viewModel

        tableView?.reloadData()
    }

    // MARK: - Private Methods

    private func setupViews() {
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInsetAdjustmentBehavior = .never

        tableView?.register(headerType: TitleHeaderView.self)
        tableView?.register(cellType: InstructionsTableViewCell.self)
        tableView?.register(cellType: SelectableTableViewCell.self)
        tableView?.register(cellType: StepperTableViewCell.self)
        tableView?.register(cellType: StopwatchTableViewCell.self)
        tableView?.register(cellType: ActionButtonTableViewCell.self)

        tableView?.accessibilityIdentifier = "VerbalFluencyViewController-tableView"
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension VerbalFluencyViewController: UITableViewDelegate {
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

extension VerbalFluencyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentSection = Section(rawValue: section), let viewModel else { return 0 }

        return viewModel.sections[currentSection]?.count ?? 0
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

            cell.accessibilityIdentifier = "VerbalFluencyViewController-InstructionsTableViewCell"

            return cell
        case .stopwatch:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StopwatchTableViewCell.className,
                                                           for: indexPath) as? StopwatchTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(delegate: interactor, description: LocalizedTable.timer.localized,
                       elapsedTime: viewModel.elapsedTime, isAscending: false)

            cell.accessibilityIdentifier = "VerbalFluencyViewController-StopwatchTableViewCell"

            return cell
        case .stepper:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StepperTableViewCell.className,
                                                           for: indexPath) as? StepperTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.numberOfSpokenWords.localized, value: Int(viewModel.countedWords),
                       delegate: interactor)

            cell.accessibilityIdentifier = "VerbalFluencyViewController-StepperTableViewCell"

            return cell
        case .question:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.className,
                                                           for: indexPath) as? SelectableTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(title: viewModel.question.question, options: viewModel.question.options,
                                        delegate: interactor, selectedQuestion: viewModel.question.selectedOption,
                                        leadingConstraint: 25))

            cell.accessibilityIdentifier = "VerbalFluencyViewController-SelectableTableViewCell"

            return cell
        case .done:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionButtonTableViewCell.className,
                                                           for: indexPath) as? ActionButtonTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.seeResults.localized, backgroundColor: .primary, delegate: interactor)

            cell.accessibilityIdentifier = "VerbalFluencyViewController-ActionButtonTableViewCell"

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

        if currentSection != .done {
            let title = switch currentSection {
            case .instructions:
                LocalizedTable.instructions.localized
            case .counting:
                LocalizedTable.counting.localized
            case .education:
                LocalizedTable.education.localized
            default:
                ""
            }
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView
                                                                            .className) as? TitleHeaderView else {
                return nil
            }

            header.setup(title: title, backgroundColor: .primary, leadingConstraint: 25)

            return header
        }

        return nil
    }
}
