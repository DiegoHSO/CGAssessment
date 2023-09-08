//
//  NoTodoEvaluationTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 08/09/23.
//

import UIKit

protocol NoTodoEvaluationDelegate: AnyObject {
    func didTapCallToAction()
}

class NoTodoEvaluationTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var noReapplicationsNextLabel: UILabel?
    @IBOutlet private weak var upToDateLabel: UILabel?
    @IBOutlet private weak var callToActionLabel: UILabel?
    @IBOutlet private weak var callToActionButton: UIButton?
    weak var delegate: NoTodoEvaluationDelegate?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabels()
    }

    // MARK: - Private Methods

    @IBAction private func callToAction(_ sender: UIButton) {
        delegate?.didTapCallToAction()
    }

    private func setupLabels() {
        noReapplicationsNextLabel?.text = LocalizedTable.Dashboard.noReapplicationsNext.localized
        upToDateLabel?.text = LocalizedTable.Dashboard.upToDate.localized
        callToActionLabel?.text = LocalizedTable.Dashboard.reviseCGAs.localized
        callToActionButton?.setTitle(LocalizedTable.Dashboard.reviseCGAsAction.localized, for: .normal)
    }
}
