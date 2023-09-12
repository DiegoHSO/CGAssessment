//
//  DashboardViewController.swift
//  AvaliacaoGeriatricaAmplaApp
//
//  Created by Diego Henrique Silva Oliveira on 05/09/23.
//

import UIKit

class DashboardViewController: UIViewController {

    // MARK: - Private Properties

    @IBOutlet private weak var backgroundView: UIView?
    @IBOutlet private weak var backgroundViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var tableView: UITableView?

    private var initialBackgroundViewHeight: CGFloat? = -1
    private var isStatusBarHidden: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
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
        navigationController?.setNavigationBarHidden(true, animated: false)
        initialBackgroundViewHeight = backgroundViewHeightConstraint?.constant

        setNeedsStatusBarAppearanceUpdate()
    }
}

extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}

extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoTodoEvaluationTableViewCell.className,
                                                       for: indexPath) as? NoTodoEvaluationTableViewCell else {
            return UITableViewCell()
        }
        /*
         guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoEvaluationTableViewCell.className,
         for: indexPath) as? TodoEvaluationTableViewCell else {
         return UITableViewCell()
         }

         cell.setup(nextApplicationDate: Date(timeIntervalSinceNow: 1063400),
         pacientName: "Danilo de Souza Pinto", pacientAge: 30,
         alteredDomains: 6, lastApplicationDate: Date(timeIntervalSinceNow: 63400))
         */

        /*
         guard let cell = tableView.dequeueReusableCell(withIdentifier: FeaturesTableViewCell.className,
         for: indexPath) as? FeaturesTableViewCell else {
         return UITableViewCell()
         }

         cell.setupFirstComponent(title: "Iniciar nova AGA", iconSymbol: "􀑇", identifier: "new_cga", delegate: nil)
         cell.setupSecondComponent(title: "Pacientes", iconSymbol: "􀝋", identifier: "pacients", delegate: nil)
         cell.setupThirdComponent(title: "Parâmetros da AGA", iconSymbol: "􀜟", identifier: "parameters", delegate: nil)
         cell.setupFourthComponent(title: "Relatórios", iconSymbol: "􀥵", identifier: "reports", delegate: nil)
         */

        /*
         guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentApplicationTableViewCell.className,
         for: indexPath) as? RecentApplicationTableViewCell else {
         return UITableViewCell()
         }


         cell.setup(pacientName: "Danilinho", pacientAge: 30, missingDomains: 4)
         */

        /*
         guard let cell = tableView.dequeueReusableCell(withIdentifier: NoRecentApplicationTableViewCell.className,
         for: indexPath) as? NoRecentApplicationTableViewCell else {
         return UITableViewCell()
         }
         */

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView
                                                                        .className) as? TitleHeaderView else {
            return nil
        }

        //         header.setup(title: "Olá, Diego", textColor: UIColor.white)
        header.setup(title: "Avaliações a reaplicar")

        return header
    }

}

extension DashboardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        isStatusBarHidden = yOffset > 0
        setNeedsStatusBarAppearanceUpdate()
        backgroundViewHeightConstraint?.constant = (initialBackgroundViewHeight ?? -1) - yOffset
        view.layoutIfNeeded()
    }
}
