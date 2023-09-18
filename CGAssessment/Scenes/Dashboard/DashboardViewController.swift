//
//  DashboardViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 05/09/23.
//

import UIKit

protocol DashboardDisplayLogic: AnyObject {
    func route(toRoute route: DashboardModels.Routing)
    func presentData(viewModel: DashboardModels.ViewModel)
}

class DashboardViewController: UIViewController, DashboardDisplayLogic {

    // MARK: - Private Properties

    @IBOutlet private weak var backgroundView: UIView?
    @IBOutlet private weak var backgroundViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var tableView: UITableView?

    private var interactor: DashboardLogic?
    private var router: DashboardRoutingLogic?
    private var viewModel: DashboardModels.ViewModel?
    private var initialBackgroundViewHeight: CGFloat? = -1
    private var isStatusBarHidden: Bool = false

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.controllerDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }

    // MARK: - Public Methods

    func setupArchitecture(interactor: DashboardLogic, router: DashboardRouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: DashboardModels.Routing) {
        switch route {
        case .cga(let cgaId):
            router?.routeToCGA(cgaId: cgaId)
        case .newCGA:
            router?.routeToNewCGA()
        case .patients:
            router?.routeToPacients()
        case .cgaParameters:
            router?.routeToCGAParameters()
        case .reports:
            router?.routeToReports()
        case .cgas:
            router?.routeToCGAs()
        }
    }

    func presentData(viewModel: DashboardModels.ViewModel) {
        setupViews()

        self.viewModel = viewModel
        tableView?.reloadData()
    }

    // MARK: - Private Methods

    private func setupTableView() {
        tableView?.dataSource = self
        tableView?.delegate = self

        tableView?.register(headerType: TitleHeaderView.self)
        tableView?.register(cellType: RecentApplicationTableViewCell.self)
        tableView?.register(cellType: NoRecentApplicationTableViewCell.self)
        tableView?.register(cellType: FeaturesTableViewCell.self)
        tableView?.register(cellType: TodoEvaluationTableViewCell.self)
        tableView?.register(cellType: NoTodoEvaluationTableViewCell.self)
    }

    private func setupViews() {
        title = LocalizedTable.home.localized
        navigationController?.setNavigationBarHidden(true, animated: false)

        initialBackgroundViewHeight = backgroundViewHeightConstraint?.constant
        setNeedsStatusBarAppearanceUpdate()
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let currentSection = DashboardModels.Section(rawValue: section) else { return 0 }
        return currentSection == .recentEvaluation ? UITableView.automaticDimension : .leastNormalMagnitude
    }
}

extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return section == 2 ? 3 : 1
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = DashboardModels.Section(rawValue: indexPath.section) else { return UITableViewCell(frame: .zero) }

        switch section {
        case .recentEvaluation:
            /*
             guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentApplicationTableViewCell.className,
             for: indexPath) as? RecentApplicationTableViewCell else {
             return UITableViewCell()
             }

             cell.setup(pacientName: "Danilinho", pacientAge: 30, missingDomains: 4)
             */

            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoRecentApplicationTableViewCell.className,
                                                           for: indexPath) as? NoRecentApplicationTableViewCell else {
                return UITableViewCell()
            }

            return cell
        case .menuOptions:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeaturesTableViewCell.className,
                                                           for: indexPath) as? FeaturesTableViewCell else {
                return UITableViewCell()
            }

            cell.setupFirstComponent(title: LocalizedTable.startNewCGA.localized,
                                     iconSymbol: "􀑇",
                                     identifier: DashboardModels.MenuOption.newCGA,
                                     delegate: interactor)

            cell.setupSecondComponent(title: LocalizedTable.patients.localized,
                                      iconSymbol: "􀝋",
                                      identifier: DashboardModels.MenuOption.patients,
                                      delegate: interactor)

            cell.setupThirdComponent(title: LocalizedTable.cgaParameters.localized,
                                     iconSymbol: "􀜟",
                                     identifier: DashboardModels.MenuOption.cgaParameters,
                                     delegate: interactor)

            cell.setupFourthComponent(title: LocalizedTable.reports.localized,
                                      iconSymbol: "􀥵",
                                      identifier: DashboardModels.MenuOption.reports,
                                      delegate: interactor)

            return cell
        case .evaluationsToReapply:
            /*
             guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoEvaluationTableViewCell.className,
             for: indexPath) as? TodoEvaluationTableViewCell else {
             return UITableViewCell()
             }

             cell.setup(nextApplicationDate: Date(timeIntervalSinceNow: 1063400),
             pacientName: "Danilo de Souza Pinto", pacientAge: 30,
             alteredDomains: 6, lastApplicationDate: Date(timeIntervalSinceNow: 63400))
             */
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoTodoEvaluationTableViewCell.className,
                                                           for: indexPath) as? NoTodoEvaluationTableViewCell else {
                return UITableViewCell()
            }
            return cell
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let currentSection = DashboardModels.Section(rawValue: section) else { return nil }

        switch currentSection {
        case .recentEvaluation, .evaluationsToReapply:
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView
                                                                            .className) as? TitleHeaderView else {
                return nil
            }

            if currentSection == .recentEvaluation {
                let title = "\(LocalizedTable.hello.localized), \(viewModel?.userName ?? LocalizedTable.howAreYou.localized)"
                header.setup(title: title, textColor: .white, leadingConstraint: 20)
            }

            if currentSection == .evaluationsToReapply {
                let title = LocalizedTable.todoEvaluations.localized
                header.setup(title: title, backgroundColor: .primary, leadingConstraint: 20)
            }

            return header
        default:
            return nil
        }
    }

}

// MARK: - UIScrollViewDelegate extension

extension DashboardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        isStatusBarHidden = yOffset > 0
        setNeedsStatusBarAppearanceUpdate()
        backgroundViewHeightConstraint?.constant = (initialBackgroundViewHeight ?? -1) - yOffset
        view.layoutIfNeeded()
    }
}
