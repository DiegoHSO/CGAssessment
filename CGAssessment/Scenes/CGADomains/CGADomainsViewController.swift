//
//  CGADomainsViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 20/09/23.
//

import UIKit

protocol CGADomainsDisplayLogic: AnyObject {
    func route(toRoute route: CGADomainsModels.Routing)
    func presentData(viewModel: CGADomainsModels.ControllerViewModel)
}

class CGADomainsViewController: UIViewController, CGADomainsDisplayLogic {

    // MARK: - Private Properties

    @IBOutlet private weak var tableView: UITableView?

    private var viewModel: CGADomainsModels.ControllerViewModel?
    private var interactor: CGADomainsLogic?
    private var router: CGADomainsRoutingLogic?

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

    // MARK: - Private Methods

    func setupViews() {
        title = LocalizedTable.cgaDomains.localized

        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInsetAdjustmentBehavior = .never

        tableView?.register(headerType: TooltipHeaderView.self)
        tableView?.register(cellType: CGADomainTableViewCell.self)
    }

    // MARK: - Public Methods

    func setupArchitecture(interactor: CGADomainsLogic, router: CGADomainsRouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: CGADomainsModels.Routing) {
        switch route {
        case .domainTests(let domain):
            router?.routeToDomainTests(domain: domain)
        }
    }

    func presentData(viewModel: CGADomainsModels.ControllerViewModel) {
        self.viewModel = viewModel

        tabBarController?.tabBar.isHidden = true
        tableView?.reloadData()
    }

}

// MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension CGADomainsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let domain = viewModel?.domains[safe: indexPath.row] else { return }
        interactor?.didSelect(domain: domain)
    }
}

extension CGADomainsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.domains.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel, let domain = viewModel.domains[safe: indexPath.row] else { return UITableViewCell(frame: .zero) }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CGADomainTableViewCell.className,
                                                       for: indexPath) as? CGADomainTableViewCell else {
            return UITableViewCell()
        }

        cell.setup(viewModel: domain.viewModel)

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TooltipHeaderView
                                                                        .className) as? TooltipHeaderView else {
            return nil
        }

        header.setup(text: LocalizedTable.cgaDomainsTooltip.localized)

        return header
    }
}