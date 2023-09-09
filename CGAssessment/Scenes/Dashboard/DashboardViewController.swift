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

        tableView?.register(cellType: NoRecentApplicationTableViewCell.self)
        tableView?.register(headerType: TitleHeaderView.self)
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
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView
                                                                        .className) as? TitleHeaderView else {
            return nil
        }

        header.setup(title: "Olá, Diego", textColor: UIColor.white)

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
