//
//  TextFieldTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 16/09/23.
//

import UIKit

protocol TextFieldDelegate: AnyObject {
    func didChangeText(text: String, identifier: LocalizedTable?)
}

class TextFieldTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var textField: UITextField?
    @IBOutlet private weak var stackViewLeadingConstraint: NSLayoutConstraint?
    private weak var delegate: TextFieldDelegate?
    private var currentText: String = ""
    private var identifier: LocalizedTable?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    // MARK: - Public Methods

    func setup(viewModel: CGAModels.TextFieldViewModel) {
        titleLabel?.text = viewModel.title
        titleLabel?.isHidden = viewModel.title == nil
        textField?.placeholder = viewModel.placeholder
        textField?.text = viewModel.text
        textField?.keyboardType = viewModel.keyboardType
        textField?.font = .compactDisplay(withStyle: .regular, size: 16)
        stackViewLeadingConstraint?.constant = viewModel.leadingConstraint

        delegate = viewModel.delegate
        identifier = viewModel.identifier
    }

    // MARK: - Private Methods

    private func setupViews() {
        textField?.delegate = self
        textField?.leftViewMode = .always
        textField?.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField?.layer.cornerRadius = 10
        textField?.clipsToBounds = true
        textField?.layer.borderWidth = 2
        textField?.layer.borderColor = UIColor.label1?.withAlphaComponent(0.5).cgColor
        textField?.backgroundColor = .background6?.withAlphaComponent(0.4)
    }
}

// MARK: - UITextFieldDelegate extension

extension TextFieldTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        self.currentText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        delegate?.didChangeText(text: currentText, identifier: identifier)

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.currentText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        delegate?.didChangeText(text: currentText, identifier: identifier)
    }
}
