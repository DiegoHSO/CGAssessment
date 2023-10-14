//
//  SuspectedAbuseViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/10/23.
//

import UIKit

protocol SuspectedAbuseDisplayLogic: AnyObject {
    func route(toRoute route: SuspectedAbuseModels.Routing)
    func presentData(viewModel: SuspectedAbuseModels.ControllerViewModel)
}

class SuspectedAbuseViewController: UIViewController, SuspectedAbuseDisplayLogic {

    // MARK: - Private Properties

    @IBOutlet private weak var tableView: UITableView?

    private typealias Section = SuspectedAbuseModels.Section
    private typealias Row = SuspectedAbuseModels.Row

    private var viewModel: SuspectedAbuseModels.ControllerViewModel?
    private var interactor: SuspectedAbuseLogic?
    private var router: SuspectedAbuseRoutingLogic?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        interactor?.controllerDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        title = LocalizedTable.suspectedAbuse.localized
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        title = LocalizedTable.assessment.localized
    }

    // MARK: - Public Methods

    func setupArchitecture(interactor: SuspectedAbuseLogic, router: SuspectedAbuseRouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: SuspectedAbuseModels.Routing) {
        switch route {
        case .chemotherapyToxicityRisk(let cgaId):
            router?.routeToChemotherapyToxicityRisk(cgaId: cgaId)
        }
    }

    func presentData(viewModel: SuspectedAbuseModels.ControllerViewModel) {
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
        tableView?.register(cellType: TextViewTableViewCell.self)
        tableView?.register(cellType: ActionButtonTableViewCell.self)
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension SuspectedAbuseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let currentSection = Section(rawValue: section) else { return .leastNormalMagnitude }
        switch currentSection {
        case .yes:
            return UITableView.automaticDimension
        case .no:
            return viewModel?.selectedOption == .secondOption || viewModel?.selectedOption == SelectableKeys.none ? .leastNormalMagnitude : UITableView.automaticDimension
        case .done:
            return .leastNormalMagnitude
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

extension SuspectedAbuseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentSection = Section(rawValue: section), let viewModel else { return 0 }

        return viewModel.sections[currentSection]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel, let section = Section(rawValue: indexPath.section) else { return UITableViewCell(frame: .zero) }

        switch viewModel.sections[section]?[safe: indexPath.row] {
        case .textView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.className,
                                                           for: indexPath) as? TextViewTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: viewModel.textViewModel)

            return cell
        case .done:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionButtonTableViewCell.className,
                                                           for: indexPath) as? ActionButtonTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.nextTest.localized, backgroundColor: .primary, delegate: interactor)

            return cell
        case .option:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.className,
                                                           for: indexPath) as? SelectableTableViewCell else {
                return UITableViewCell()
            }

            switch section {
            case .yes:
                cell.setup(viewModel: .init(title: nil, options: [.firstOption: .yesKey],
                                            delegate: interactor, selectedQuestion: viewModel.selectedOption,
                                            leadingConstraint: 30))
            case .no:
                cell.setup(viewModel: .init(title: nil, options: [.secondOption: .noKey],
                                            delegate: interactor, selectedQuestion: viewModel.selectedOption,
                                            leadingConstraint: 30))
            case .done:
                return UITableViewCell(frame: .zero)
            }

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
