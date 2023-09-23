//
//  SingleDomainViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 23/09/23.
//

import UIKit

protocol SingleDomainDisplayLogic: AnyObject {
    func route(toRoute route: SingleDomainModels.Routing)
    func presentData(viewModel: SingleDomainModels.ControllerViewModel)
}

class SingleDomainViewController: UIViewController {

    // MARK: - Private Properties
    
    @IBOutlet private weak var tableView: UITableView?
    
    private var viewModel: SingleDomainModels.ControllerViewModel?
    private var interactor: SingleDomainLogic?
    private var router: SingleDomainRoutingLogic?
    
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
    
    func setupArchitecture(interactor: SingleDomainLogic, router: SingleDomainRouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: SingleDomainModels.Routing) {
        switch route {
        case .domainTest(let test):
            router?.routeToSingleTest(test: test)
        }
    }
    
    func presentData(viewModel: SingleDomainModels.ControllerViewModel) {
        self.viewModel = viewModel

        tabBarController?.tabBar.isHidden = true
        tableView?.reloadData()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        title = LocalizedTable.domain.localized

        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInsetAdjustmentBehavior = .never

        tableView?.register(cellType: TestTableViewCell.self)
    }
}


// MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension SingleDomainViewController: UITableViewDelegate {
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

extension SingleDomainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.domains.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel, let domain = viewModel.domains[safe: indexPath.row] else { return UITableViewCell(frame: .zero) }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: TestTableViewCell.className,
                                                       for: indexPath) as? TestTableViewCell else {
            return UITableViewCell()
        }

        cell.setup(viewModel: domain.viewModel)

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections ?? 0
    }
}
