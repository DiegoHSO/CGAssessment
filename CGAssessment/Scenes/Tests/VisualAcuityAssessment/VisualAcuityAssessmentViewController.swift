//
//  VisualAcuityAssessmentViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 10/10/23.
//

import UIKit

protocol VisualAcuityAssessmentDisplayLogic: AnyObject {
    func route(toRoute route: VisualAcuityAssessmentModels.Routing)
    func presentData(viewModel: VisualAcuityAssessmentModels.ControllerViewModel)
}

class VisualAcuityAssessmentViewController: UIViewController, VisualAcuityAssessmentDisplayLogic {

    // MARK: - Private Properties

    @IBOutlet private weak var tableView: UITableView?

    private typealias Section = VisualAcuityAssessmentModels.Section
    private typealias Row = VisualAcuityAssessmentModels.Row

    private var viewModel: VisualAcuityAssessmentModels.ControllerViewModel?
    private var interactor: VisualAcuityAssessmentLogic?
    private var router: VisualAcuityAssessmentRoutingLogic?
    private lazy var tableViewHeader: UIView? = {
        guard let header = tableView?.dequeueReusableHeaderFooterView(withIdentifier: TooltipHeaderView
                                                                        .className) as? TooltipHeaderView else {
            return UIView()
        }

        header.setup(text: LocalizedTable.visualAcuityAssessmentTootip.localized)

        return header
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        interactor?.controllerDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        title = LocalizedTable.visualAcuityAssessment.localized
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        title = LocalizedTable.assessment.localized
    }

    // MARK: - Public Methods

    func setupArchitecture(interactor: VisualAcuityAssessmentLogic, router: VisualAcuityAssessmentRouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: VisualAcuityAssessmentModels.Routing) {
        switch route {
        case .testResults(let test, let results, let cgaId):
            router?.routeToTestResults(test: test, results: results, cgaId: cgaId)
        }
    }

    func presentData(viewModel: VisualAcuityAssessmentModels.ControllerViewModel) {
        self.viewModel = viewModel

        tableView?.reloadData()
    }

    // MARK: - Private Methods

    private func setupViews() {
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInsetAdjustmentBehavior = .never

        tableView?.register(headerType: TitleHeaderView.self)
        tableView?.register(headerType: TooltipHeaderView.self)
        tableView?.register(cellType: InstructionsTableViewCell.self)
        tableView?.register(cellType: SelectableTableViewCell.self)
        tableView?.register(cellType: ImageTableViewCell.self)
        tableView?.register(cellType: GroupedButtonsTableViewCell.self)
        tableView?.register(cellType: ActionButtonTableViewCell.self)
        
        tableView?.tableHeaderView = tableViewHeader
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension VisualAcuityAssessmentViewController: UITableViewDelegate {
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

extension VisualAcuityAssessmentViewController: UITableViewDataSource {
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

            return cell
        case .buttons:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupedButtonsTableViewCell.className,
                                                           for: indexPath) as? GroupedButtonsTableViewCell else {
                return UITableViewCell()
            }
            
            cell.setup(viewModels: viewModel.buttons)
            
            return cell
        case .image:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.className,
                                                           for: indexPath) as? ImageTableViewCell else {
                return UITableViewCell()
            }
            
            cell.setup(image: UIImage(named: viewModel.imageName), borderInImage: false)
            
            return cell
        case .question:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.className,
                                                           for: indexPath) as? SelectableTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(title: viewModel.question.question, options: viewModel.question.options,
                                        delegate: interactor, selectedQuestion: viewModel.question.selectedOption,
                                        leadingConstraint: 35))

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

        if currentSection != .done {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView
                                                                            .className) as? TitleHeaderView else {
                return nil
            }

            header.setup(title: LocalizedTable.instructions.localized,
                         backgroundColor: .primary, leadingConstraint: 25)

            return header
        }

        return nil
    }
}
