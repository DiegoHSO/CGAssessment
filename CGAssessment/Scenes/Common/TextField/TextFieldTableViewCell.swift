//
//  TextFieldTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 16/09/23.
//

import UIKit

protocol TextFieldDelegate: AnyObject {
    func didChangeText(text: String?)
}

class TextFieldTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var textField: UITextField?
    private weak var delegate: TextFieldDelegate?
    private var currentText: String?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    // MARK: - Public Methods

    func setup(title: String?, text: String?, placeholder: String?, delegate: TextFieldDelegate?) {
        titleLabel?.text = title
        textField?.placeholder = placeholder
        textField?.text = text

        self.delegate = delegate
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
        textField?.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        self.currentText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        delegate?.didChangeText(text: currentText)
    }

}

// MARK: - UITextFieldDelegate extension

extension TextFieldTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        currentText = nil
        return true
    }
}
