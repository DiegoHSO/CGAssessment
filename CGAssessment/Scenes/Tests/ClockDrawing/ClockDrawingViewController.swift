//
//  ClockDrawingViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import UIKit

protocol ClockDrawingDisplayLogic: AnyObject {
    func route(toRoute route: ClockDrawingModels.Routing)
    func presentData(viewModel: ClockDrawingModels.ControllerViewModel)
}

class ClockDrawingViewController: UIViewController, ClockDrawingDisplayLogic {

    @IBOutlet private weak var tableView: UITableView?

    private typealias Section = ClockDrawingModels.Section
    private typealias Row = ClockDrawingModels.Row

    private var viewModel: ClockDrawingModels.ControllerViewModel?
    private var interactor: ClockDrawingLogic?
    private var router: ClockDrawingRoutingLogic?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        interactor?.controllerDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        title = LocalizedTable.clockDrawingTest.localized
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        title = LocalizedTable.assessment.localized
    }

    // MARK: - Public Methods

    func setupArchitecture(interactor: ClockDrawingLogic, router: ClockDrawingRouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: ClockDrawingModels.Routing) {
        switch route {
        case .testResults(let test, let results, let cgaId):
            router?.routeToTestResults(test: test, results: results, cgaId: cgaId)
        }
    }

    func presentData(viewModel: ClockDrawingModels.ControllerViewModel) {
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
        tableView?.register(cellType: InstructionsTableViewCell.self)
        tableView?.register(cellType: BinaryOptionsTableViewCell.self)
        tableView?.register(cellType: ActionButtonTableViewCell.self)
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension ClockDrawingViewController: UITableViewDelegate {
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

extension ClockDrawingViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentSection = Section(rawValue: section), let viewModel else { return 0 }

        return viewModel.sections[currentSection]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel, let section = Section(rawValue: indexPath.section),
              let row = viewModel.sections[section]?[safe: indexPath.row] else { return UITableViewCell(frame: .zero) }

        switch row {
        case .done:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionButtonTableViewCell.className,
                                                           for: indexPath) as? ActionButtonTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.seeResults.localized, backgroundColor: .primary, delegate: interactor)

            return cell
        case .binaryQuestion:
            guard let questionViewModel = viewModel.binaryQuestions[section] else { return UITableViewCell(frame: .zero) }

            guard let cell = tableView.dequeueReusableCell(withIdentifier: BinaryOptionsTableViewCell.className,
                                                           for: indexPath) as? BinaryOptionsTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: questionViewModel)

            return cell
        case .instructions:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InstructionsTableViewCell.className,
                                                           for: indexPath) as? InstructionsTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(instructions: viewModel.instructions))

            return cell
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.keys.count ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let currentSection = Section(rawValue: section) else { return nil }

        if currentSection != .done {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView
                                                                            .className) as? TitleHeaderView else {
                return nil
            }

            let headerTitle: String = switch currentSection {
            case .instructions:
                LocalizedTable.instructions.localized
            case .firstBinaryQuestion:
                LocalizedTable.outline.localized
            case .secondBinaryQuestion:
                LocalizedTable.numbers.localized
            case .thirdBinaryQuestion:
                LocalizedTable.pointers.localized
            default:
                ""
            }

            header.setup(title: headerTitle, backgroundColor: .primary, leadingConstraint: 25)

            return header
        }

        return nil
    }
}
