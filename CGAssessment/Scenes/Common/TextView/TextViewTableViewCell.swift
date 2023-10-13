//
//  TextViewTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/10/23.
//

import UIKit

protocol TextViewDelegate: AnyObject {
    func didChangeText(text: String, identifier: LocalizedTable?)
}

class TextViewTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var textView: UITextView?
    @IBOutlet private weak var trailingConstraint: NSLayoutConstraint?
    @IBOutlet private weak var leadingConstraint: NSLayoutConstraint?
    private var placeholder: String?
    private var currentText: String = ""
    private var identifier: LocalizedTable?
    private weak var delegate: TextViewDelegate?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    // MARK: - Public Methods

    func setup(viewModel: CGAModels.TextViewViewModel) {
        titleLabel?.text = viewModel.title
        titleLabel?.font = .compactDisplay(withStyle: .medium, size: 16)
        titleLabel?.isHidden = viewModel.title == nil
        trailingConstraint?.constant = viewModel.horizontalConstraint
        leadingConstraint?.constant = viewModel.horizontalConstraint
        textView?.font = .compactDisplay(withStyle: .regular, size: 16)

        if let text = viewModel.text {
            textView?.text = text.isEmpty ? viewModel.placeholder : text
            textView?.textColor = text.isEmpty ? .placeholderText : .label1

        } else {
            textView?.text = viewModel.placeholder
            textView?.textColor = .placeholderText
        }

        self.placeholder = viewModel.placeholder
        self.delegate = viewModel.delegate
        self.currentText = viewModel.text ?? ""
        self.identifier = viewModel.identifier
    }

    // MARK: - Private Methods

    private func setupViews() {
        textView?.layer.masksToBounds = true
        textView?.layer.cornerRadius = 15
        textView?.layer.borderWidth = 2
        textView?.layer.borderColor = UIColor.label3?.cgColor
        textView?.backgroundColor = .background6?.withAlphaComponent(0.4)
        textView?.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        textView?.delegate = self

        textView?.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
    }

    @objc private func doneButtonClicked(_ sender: Any) {
        self.currentText = textView?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.currentText = currentText == placeholder ? "" : currentText
        delegate?.didChangeText(text: currentText, identifier: identifier)
    }
}

// MARK: - UITextViewDelegate extension

extension TextViewTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = textView.text == placeholder ? "" : textView.text
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        self.currentText = textView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.currentText = currentText == placeholder ? "" : currentText
        delegate?.didChangeText(text: currentText, identifier: identifier)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = placeholder
            textView.textColor = UIColor.placeholderText

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
        else if textView.textColor == UIColor.placeholderText && !text.isEmpty {
            textView.textColor = UIColor.label1
            textView.text = text
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.window != nil {
            if textView.textColor == UIColor.placeholderText {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
