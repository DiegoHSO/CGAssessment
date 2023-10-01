//
//  WalkingSpeedViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import UIKit

protocol WalkingSpeedDisplayLogic: AnyObject {
    func route(toRoute route: WalkingSpeedModels.Routing)
    func presentData(viewModel: WalkingSpeedModels.ControllerViewModel)
}

class WalkingSpeedViewController: UIViewController, WalkingSpeedDisplayLogic {

    // MARK: - Private Properties

    @IBOutlet private weak var tableView: UITableView?

    private typealias Section = WalkingSpeedModels.Section
    private typealias Row = WalkingSpeedModels.Row

    private var viewModel: WalkingSpeedModels.ControllerViewModel?
    private var interactor: WalkingSpeedLogic?
    private var router: WalkingSpeedRoutingLogic?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        interactor?.controllerDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        title = LocalizedTable.walkingSpeed.localized
    }

    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        title = LocalizedTable.assessment.localized
    }

    // MARK: - Public Methods

    func setupArchitecture(interactor: WalkingSpeedLogic, router: WalkingSpeedRouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: WalkingSpeedModels.Routing) {
        switch route {
        case .testResults(let test, let results, let cgaId):
            router?.routeToTestResults(test: test, results: results, cgaId: cgaId)
        }
    }

    func presentData(viewModel: WalkingSpeedModels.ControllerViewModel) {
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
        tableView?.register(cellType: TextFieldTableViewCell.self)
        tableView?.register(cellType: StopwatchTableViewCell.self)
        tableView?.register(cellType: ActionButtonTableViewCell.self)
        tableView?.register(cellType: TooltipTableViewCell.self)
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension WalkingSpeedViewController: UITableViewDelegate {
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

extension WalkingSpeedViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel, let section = Section(rawValue: indexPath.section) else { return }

        switch viewModel.sections[section]?[safe: indexPath.row] {
        case .firstStopwatchTooltip:
            interactor?.didSelect(option: .first)
        case .secondStopwatchTooltip:
            interactor?.didSelect(option: .second)
        case .thirdStopwatchTooltip:
            interactor?.didSelect(option: .third)
        default:
            return
        }
    }

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
            return viewModel.sections[.done]?.count ?? 0
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
        case .firstTextFieldStopwatch:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.className,
                                                           for: indexPath) as? TextFieldTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(title: LocalizedTable.firstMeasurement.localized,
                                        text: viewModel.typedFirstTime, placeholder: LocalizedTable.timeTakenSeconds.localized,
                                        delegate: interactor, keyboardType: .decimalPad, identifier: .firstMeasurement))

            return cell
        case .secondTextFieldStopwatch:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.className,
                                                           for: indexPath) as? TextFieldTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(title: LocalizedTable.secondMeasurement.localized,
                                        text: viewModel.typedSecondTime, placeholder: LocalizedTable.timeTakenSeconds.localized,
                                        delegate: interactor, keyboardType: .decimalPad, identifier: .secondMeasurement))

            return cell
        case .thirdTextFieldStopwatch:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.className,
                                                           for: indexPath) as? TextFieldTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(title: LocalizedTable.thirdMeasurement.localized,
                                        text: viewModel.typedThirdTime, placeholder: LocalizedTable.timeTakenSeconds.localized,
                                        delegate: interactor, keyboardType: .decimalPad, identifier: .thirdMeasurement))

            return cell
        case .firstStopwatch:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StopwatchTableViewCell.className,
                                                           for: indexPath) as? StopwatchTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(delegate: interactor, description: LocalizedTable.firstMeasurement.localized,
                       elapsedTime: viewModel.firstStopwatchTime)

            return cell
        case .secondStopwatch:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StopwatchTableViewCell.className,
                                                           for: indexPath) as? StopwatchTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(delegate: interactor, description: LocalizedTable.secondMeasurement.localized,
                       elapsedTime: viewModel.secondStopwatchTime)

            return cell
        case .thirdStopwatch:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StopwatchTableViewCell.className,
                                                           for: indexPath) as? StopwatchTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(delegate: interactor, description: LocalizedTable.thirdMeasurement.localized,
                       elapsedTime: viewModel.thirdStopwatchTime)

            return cell
        case .firstStopwatchTooltip:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TooltipTableViewCell.className,
                                                           for: indexPath) as? TooltipTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(text: LocalizedTable.firstMeasurement.localized, symbol: "􀐬")

            return cell
        case .secondStopwatchTooltip:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TooltipTableViewCell.className,
                                                           for: indexPath) as? TooltipTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(text: LocalizedTable.secondMeasurement.localized, symbol: "􀐬")

            return cell
        case .thirdStopwatchTooltip:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TooltipTableViewCell.className,
                                                           for: indexPath) as? TooltipTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(text: LocalizedTable.thirdMeasurement.localized, symbol: "􀐬")

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
