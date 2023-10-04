//
//  ResultsViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import UIKit

protocol ResultsDisplayLogic: AnyObject {
    func route(toRoute route: ResultsModels.Routing)
    func presentData(viewModel: ResultsModels.ViewModel)
}

class ResultsViewController: UIViewController, ResultsDisplayLogic {

    // MARK: - Private Properties

    @IBOutlet private weak var tableView: UITableView?

    private typealias Section = ResultsModels.Section
    private typealias Row = ResultsModels.Row

    private var viewModel: ResultsModels.ViewModel?
    private var interactor: ResultsLogic?
    private var router: ResultsRoutingLogic?

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

    func setupArchitecture(interactor: ResultsLogic, router: ResultsRouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: ResultsModels.Routing) {
        switch route {
        case .nextTest(let test):
            router?.routeToNextTest(test: test)
        case .routeBack(let domain):
            router?.routeBack(domain: domain)
        case .sarcopeniaAssessment:
            router?.routeToSarcopeniaAssessment()
        }
    }

    func presentData(viewModel: ResultsModels.ViewModel) {
        self.viewModel = viewModel

        tabBarController?.tabBar.isHidden = true
        tableView?.reloadData()
    }

    // MARK: - Private Methods

    private func setupViews() {
        title = LocalizedTable.result.localized

        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInsetAdjustmentBehavior = .never

        tableView?.register(cellType: ResultsTableViewCell.self)
        tableView?.register(cellType: TitleTableViewCell.self)
        tableView?.register(cellType: ActionButtonTableViewCell.self)
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension ResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let currentSection = Section(rawValue: section) else { return .leastNormalMagnitude }
        return currentSection == .results ? UITableView.automaticDimension : .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

extension ResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentSection = Section(rawValue: section), let viewModel else { return 0 }

        return viewModel.sections[currentSection]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel, let section = Section(rawValue: indexPath.section) else { return UITableViewCell(frame: .zero) }

        switch viewModel.sections[section]?[safe: indexPath.row] {
        case .results:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultsTableViewCell.className,
                                                           for: indexPath) as? ResultsTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(testName: viewModel.testName, results: viewModel.results,
                                        resultType: viewModel.resultType))

            return cell

        case .label:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.className,
                                                           for: indexPath) as? TitleTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.sarcopeniaAssessmentNextStep.localized, fontStyle: .medium)

            return cell
        case .nextTest:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionButtonTableViewCell.className,
                                                           for: indexPath) as? ActionButtonTableViewCell else {
                return UITableViewCell()
            }

            if viewModel.testName == LocalizedTable.sarcopeniaScreening.localized, viewModel.resultType == .bad {
                cell.setup(title: LocalizedTable.secondStep.localized, backgroundColor: .primary, delegate: interactor)
            } else {
                cell.setup(title: LocalizedTable.nextTest.localized, backgroundColor: .primary, delegate: interactor)
            }

            return cell
        case .goBack:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionButtonTableViewCell.className,
                                                           for: indexPath) as? ActionButtonTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.returnKey.localized,
                       backgroundColor: .background12?.withAlphaComponent(0.17),
                       delegate: interactor)

            return cell
        default:
            return UITableViewCell()
        }

    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.keys.count ?? 0
    }
}
