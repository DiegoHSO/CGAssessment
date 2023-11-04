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

class CGADomainsViewController: UIViewController, CGADomainsDisplayLogic, StatusViewProtocol {

    // MARK: - Private Properties

    @IBOutlet internal weak var tableView: UITableView?
    internal var isSelected: Bool = false
    internal var statusViewModel: CGAModels.StatusViewModel? { viewModel?.statusViewModel }

    private typealias Domain = CGADomainsModels.Domain

    private var viewModel: CGADomainsModels.ControllerViewModel?
    private var interactor: CGADomainsLogic?
    private var router: CGADomainsRoutingLogic?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBarButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.controllerDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        title = LocalizedTable.domains.localized
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let headerView = tableView?.tableHeaderView else { return }
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableView?.tableHeaderView = headerView
            tableView?.layoutIfNeeded()
        }
    }

    // MARK: - Public Methods

    func setupArchitecture(interactor: CGADomainsLogic, router: CGADomainsRouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: CGADomainsModels.Routing) {
        switch route {
        case .domainTests(let domain, let cgaId):
            router?.routeToDomainTests(domain: domain, cgaId: cgaId)
        }
    }

    func presentData(viewModel: CGADomainsModels.ControllerViewModel) {
        self.viewModel = viewModel

        title = LocalizedTable.cgaDomains.localized
        tabBarController?.tabBar.isHidden = true
        tableView?.reloadData()
    }

    // MARK: - Private Methods

    private func setupViews() {
        title = LocalizedTable.cgaDomains.localized

        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInsetAdjustmentBehavior = .never

        tableView?.register(headerType: StatusHeaderView.self)
        tableView?.register(headerType: TooltipHeaderView.self)
        tableView?.register(cellType: CGADomainTableViewCell.self)

        tableView?.accessibilityIdentifier = "CGADomainsViewController-tableView"
    }

    private func setupBarButtonItem() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"),
                                        style: .plain, target: self,
                                        action: #selector(infoButtonTapped))

        barButton.accessibilityIdentifier = "CGADomainsViewController-infoButton"
        self.navigationItem.rightBarButtonItem = barButton
    }

    @objc private func infoButtonTapped() {
        isSelected.toggle()
        tableView?.tableHeaderView = currentHeader
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: isSelected ? "info.circle.fill" : "info.circle")
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
        guard let domain = Domain(rawValue: indexPath.row) else { return }
        interactor?.didSelect(domain: domain)
    }
}

extension CGADomainsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Domain.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel, let domain = Domain(rawValue: indexPath.row), let tests = viewModel.domains[domain] else { return UITableViewCell(frame: .zero) }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CGADomainTableViewCell.className,
                                                       for: indexPath) as? CGADomainTableViewCell else {
            return UITableViewCell()
        }

        cell.setup(viewModel: .init(name: domain.title, symbol: domain.symbol,
                                    tests: tests))

        cell.accessibilityIdentifier = "CGADomainsViewController-CGADomainTableViewCell-\(indexPath.row)"

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
