//
//  NoTodoEvaluationTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 08/09/23.
//

import UIKit

protocol NoTodoEvaluationDelegate: AnyObject {
    func didTapToReviewCGAs()
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

    // MARK: - Public Methods

    func setup(delegate: NoTodoEvaluationDelegate?) {
        self.delegate = delegate
    }

    // MARK: - Private Methods

    @IBAction private func callToAction(_ sender: UIButton) {
        delegate?.didTapToReviewCGAs()
    }

    private func setupLabels() {
        noReapplicationsNextLabel?.text = LocalizedTable.noReapplicationsNext.localized
        upToDateLabel?.text = LocalizedTable.upToDate.localized
        callToActionLabel?.text = LocalizedTable.reviseCGAs.localized
        callToActionButton?.setTitle(LocalizedTable.reviseCGAsAction.localized, for: .normal)
    }
}
