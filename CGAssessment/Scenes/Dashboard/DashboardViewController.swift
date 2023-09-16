//
//  DashboardViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 05/09/23.
//

import UIKit

// TODO: Move to Models file
typealias Tabs = (
    home: UIViewController?,
    cgas: UIViewController?,
    preferences: UIViewController?
)

class DashboardViewController: UIViewController {

    // MARK: - Private Properties

    @IBOutlet private weak var backgroundView: UIView?
    @IBOutlet private weak var backgroundViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var tableView: UITableView?

    private var initialBackgroundViewHeight: CGFloat? = -1
    private var isStatusBarHidden: Bool = false

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
    }

    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
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
        return section == 0 ? UITableView.automaticDimension : .leastNormalMagnitude
    }
}

extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return section == 2 ? 3 : 1
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
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
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeaturesTableViewCell.className,
                                                           for: indexPath) as? FeaturesTableViewCell else {
                return UITableViewCell()
            }

            cell.setupFirstComponent(title: "Iniciar nova AGA", iconSymbol: "􀑇", identifier: "new_cga", delegate: nil)
            cell.setupSecondComponent(title: "Pacientes", iconSymbol: "􀝋", identifier: "pacients", delegate: nil)
            cell.setupThirdComponent(title: "Parâmetros da AGA", iconSymbol: "􀜟", identifier: "parameters", delegate: nil)
            cell.setupFourthComponent(title: "Relatórios", iconSymbol: "􀥵", identifier: "reports", delegate: nil)
            return cell
        case 2:
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
        default:
            return UITableViewCell()
        }
        /*
         guard let cell = tableView.dequeueReusableCell(withIdentifier: NoTodoEvaluationTableViewCell.className,
         for: indexPath) as? NoTodoEvaluationTableViewCell else {
         return UITableViewCell()
         }
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

         return cell
         */
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || section == 2 {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView
                                                                            .className) as? TitleHeaderView else {
                return nil
            }

            if section == 0 { header.setup(title: "Olá, Diego", textColor: .white) }
            if section == 2 { header.setup(title: "Avaliações a reaplicar", backgroundColor: .primary) }

            return header
        }

        return nil

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
