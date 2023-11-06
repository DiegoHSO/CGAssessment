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

class SingleDomainViewController: UIViewController, SingleDomainDisplayLogic, StatusViewProtocol {

    // MARK: - Private Properties

    @IBOutlet internal weak var tableView: UITableView?
    internal var isSelected: Bool = false
    internal var statusViewModel: CGAModels.StatusViewModel? { viewModel?.statusViewModel }

    private var viewModel: SingleDomainModels.ControllerViewModel?
    private var interactor: SingleDomainLogic?
    private var router: SingleDomainRoutingLogic?

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

    func setupArchitecture(interactor: SingleDomainLogic, router: SingleDomainRouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: SingleDomainModels.Routing) {
        switch route {
        case .domainTest(let test, let cgaId):
            router?.routeToSingleTest(test: test, cgaId: cgaId)
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

        tableView?.register(headerType: StatusHeaderView.self)
        tableView?.register(headerType: TitleHeaderView.self)
        tableView?.register(cellType: TestTableViewCell.self)

        tableView?.accessibilityIdentifier = "SingleDomainViewController-tableView"
    }

    private func setupBarButtonItem() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"),
                                        style: .plain, target: self,
                                        action: #selector(infoButtonTapped))

        barButton.accessibilityIdentifier = "SingleDomainViewController-infoButton"
        self.navigationItem.rightBarButtonItem = barButton
    }

    @objc private func infoButtonTapped() {
        isSelected.toggle()
        tableView?.tableHeaderView = currentHeader
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: isSelected ? "info.circle.fill" : "info.circle")
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
        guard let test = viewModel?.tests[safe: indexPath.row]?.test else { return }
        interactor?.didSelect(test: test)
    }
}

extension SingleDomainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.tests.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel, let test = viewModel.tests[safe: indexPath.row] else { return UITableViewCell(frame: .zero) }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: TestTableViewCell.className,
                                                       for: indexPath) as? TestTableViewCell else {
            return UITableViewCell()
        }

        cell.setup(viewModel: test)

        cell.accessibilityIdentifier = "SingleDomainViewController-TestTableViewCell-\(indexPath.row)"

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel, let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView
                                                                                        .className) as? TitleHeaderView else {
            return nil
        }

        header.setup(title: viewModel.domain.title)

        return header
    }
}
