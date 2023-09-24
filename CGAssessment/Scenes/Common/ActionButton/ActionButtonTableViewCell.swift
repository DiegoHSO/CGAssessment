//
//  ActionButtonTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 16/09/23.
//

import UIKit

protocol ActionButtonDelegate: AnyObject {
    func didTapActionButton(identifier: String?)
}

class ActionButtonTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var actionButton: UIButton?
    private weak var delegate: ActionButtonDelegate?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    // MARK: - Public Methods

    func setup(title: String, backgroundColor: UIColor?, delegate: ActionButtonDelegate?) {
        actionButton?.setTitle(title, for: .normal)
        actionButton?.backgroundColor = backgroundColor

        self.delegate = delegate
    }

    // MARK: - Private Methods

    private func setupView() {
        actionButton?.layer.borderColor = UIColor.label3?.cgColor
        actionButton?.layer.borderWidth = 1.75
        actionButton?.layer.cornerRadius = 18
    }

    @IBAction func didTapActionButton(_ sender: UIButton) {
        delegate?.didTapActionButton(identifier: actionButton?.titleLabel?.text)
    }

}
