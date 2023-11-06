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
        setupViews()
    }

    // MARK: - Public Methods

    func setup(delegate: NoTodoEvaluationDelegate?) {
        self.delegate = delegate
    }

    // MARK: - Private Methods

    @IBAction private func callToAction(_ sender: UIButton) {
        delegate?.didTapToReviewCGAs()
    }

    private func setupViews() {
        noReapplicationsNextLabel?.text = LocalizedTable.noReapplicationsNext.localized
        noReapplicationsNextLabel?.font = .compactDisplay(withStyle: .semibold, size: 15)
        upToDateLabel?.text = LocalizedTable.upToDate.localized
        upToDateLabel?.font = .compactDisplay(withStyle: .medium, size: 15)
        callToActionLabel?.text = LocalizedTable.reviseCGAs.localized
        callToActionLabel?.font = .compactDisplay(withStyle: .medium, size: 15)
        callToActionButton?.setTitle(LocalizedTable.reviseCGAsAction.localized, for: .normal)
        callToActionButton?.titleLabel?.font = .compactDisplay(withStyle: .medium, size: 15)
        callToActionButton?.accessibilityIdentifier = "NoTodoEvaluationTableViewCell-callToActionButton"
    }
}
