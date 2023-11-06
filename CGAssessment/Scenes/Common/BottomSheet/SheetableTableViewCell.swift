//
//  SheetableTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import UIKit

protocol SheetableDelegate: AnyObject {
    func didTapPicker(identifier: LocalizedTable?)
}

class SheetableTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var pickerNameLabel: UILabel?
    @IBOutlet private weak var pickerValueButton: UIButton?
    @IBOutlet private weak var leadingConstraint: NSLayoutConstraint?
    @IBOutlet private weak var trailingConstraint: NSLayoutConstraint?
    private weak var delegate: SheetableDelegate?
    private var identifier: LocalizedTable?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    // MARK: - Public Methods

    func setup(viewModel: CGAModels.SheetableViewModel) {
        titleLabel?.text = viewModel.title
        titleLabel?.isHidden = viewModel.title == nil
        pickerNameLabel?.text = viewModel.pickerName?.localized
        pickerValueButton?.setTitle(viewModel.pickerValue, for: .normal)
        leadingConstraint?.constant = viewModel.horizontalConstraint
        trailingConstraint?.constant = viewModel.horizontalConstraint
        pickerValueButton?.accessibilityIdentifier = "SheetableTableViewCell-\(viewModel.pickerName?.rawValue ?? "")"
        identifier = viewModel.pickerName
        delegate = viewModel.delegate
    }

    // MARK: - Private Methods

    private func setupViews() {
        titleLabel?.font = .compactDisplay(withStyle: .medium, size: 16)
        pickerNameLabel?.font = .compactDisplay(withStyle: .regular, size: 15)
        pickerValueButton?.titleLabel?.font = .compactDisplay(withStyle: .regular, size: 16)
        pickerValueButton?.layer.cornerRadius = 6
        pickerValueButton?.backgroundColor = .background6?.withAlphaComponent(0.5)
    }

    @IBAction private func pickerValueAction(_ sender: UIButton) {
        delegate?.didTapPicker(identifier: identifier)
    }

}
