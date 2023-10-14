//
//  StatusViewProtocol.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 04/10/23.
//

import UIKit

protocol StatusViewProtocol: UIViewController {
    var tableView: UITableView? { get }
    var statusHeaderView: UIView? { get }
    var currentHeader: UIView? { get }
    var isSelected: Bool { get }
    var statusViewModel: CGAModels.StatusViewModel? { get }
}

extension StatusViewProtocol {
    var currentHeader: UIView? {
        guard isSelected else { return nil }

        return statusHeaderView ?? cgasSubtitleHeaderView
    }

    var statusHeaderView: UIView? {
        guard let statusViewModel, let header = tableView?.dequeueReusableHeaderFooterView(withIdentifier: StatusHeaderView
                                                                                            .className) as? StatusHeaderView else {
            return nil
        }

        header.frame = CGRect(x: header.frame.origin.x,
                              y: header.frame.origin.y,
                              width: header.frame.width,
                              height: header.frame.height)

        header.setup(viewModel: statusViewModel)

        return header
    }

    var cgasSubtitleHeaderView: UIView? {
        guard let header = tableView?.dequeueReusableHeaderFooterView(withIdentifier: CGAsSubtitleHeaderView
                                                                        .className) as?         CGAsSubtitleHeaderView else {
            return nil
        }

        header.frame = CGRect(x: header.frame.origin.x,
                              y: header.frame.origin.y,
                              width: header.frame.width,
                              height: header.frame.height)

        return header
    }

}
