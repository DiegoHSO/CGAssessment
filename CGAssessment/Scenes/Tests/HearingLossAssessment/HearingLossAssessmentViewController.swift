//
//  HearingLossAssessmentViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import UIKit

protocol HearingLossAssessmentDisplayLogic: AnyObject {
    func route(toRoute route: HearingLossAssessmentModels.Routing)
    func presentData(viewModel: HearingLossAssessmentModels.ControllerViewModel)
}

class HearingLossAssessmentViewController: UIViewController, HearingLossAssessmentDisplayLogic {

    // MARK: - Private Properties

    @IBOutlet private weak var tableView: UITableView?

    private typealias Section = HearingLossAssessmentModels.Section
    private typealias Row = HearingLossAssessmentModels.Row

    private var viewModel: HearingLossAssessmentModels.ControllerViewModel?
    private var interactor: HearingLossAssessmentLogic?
    private var router: HearingLossAssessmentRoutingLogic?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        interactor?.controllerDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        title = LocalizedTable.hearingLossAssessment.localized
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        title = LocalizedTable.assessment.localized
    }

    // MARK: - Public Methods

    func setupArchitecture(interactor: HearingLossAssessmentLogic, router: HearingLossAssessmentRouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: HearingLossAssessmentModels.Routing) {
        switch route {
        case .katzScale(let cgaId):
            router?.routeToKatzScaleTest(cgaId: cgaId)
        }
    }

    func presentData(viewModel: HearingLossAssessmentModels.ControllerViewModel) {
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
        tableView?.register(cellType: TooltipTableViewCell.self)
        tableView?.register(cellType: InstructionsTableViewCell.self)
        tableView?.register(cellType: ActionButtonTableViewCell.self)
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension HearingLossAssessmentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

extension HearingLossAssessmentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentSection = Section(rawValue: section), let viewModel else { return 0 }

        return viewModel.sections[currentSection]?.count ?? 0
    }

    // swiftlint:disable:next function_body_length cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel, let section = Section(rawValue: indexPath.section) else { return UITableViewCell(frame: .zero) }

        switch viewModel.sections[section]?[safe: indexPath.row] {
        case .header:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TooltipTableViewCell.className,
                                                           for: indexPath) as? TooltipTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(text: LocalizedTable.hearingLossAssessmentTooltip.localized, symbol: "􀅵", bottomConstraint: 0)

            return cell
        case .instructions:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InstructionsTableViewCell.className,
                                                           for: indexPath) as? InstructionsTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(instructions: viewModel.instructions))

            return cell
        case .done:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionButtonTableViewCell.className,
                                                           for: indexPath) as? ActionButtonTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.nextTest.localized, backgroundColor: .primary, delegate: interactor)

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

        if currentSection == .test {
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
