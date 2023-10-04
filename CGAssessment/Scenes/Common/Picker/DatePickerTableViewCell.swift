//
//  DatePickerTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 16/09/23.
//

import UIKit

protocol DatePickerDelegate: AnyObject {
    func didSelectDate(date: Date)
}

class DatePickerTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var datePicker: UIDatePicker?
    @IBOutlet private weak var stackViewLeadingConstraint: NSLayoutConstraint?
    private weak var delegate: DatePickerDelegate?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    // MARK: - Public Methods

    func setup(viewModel: CGAModels.DatePickerViewModel) {
        titleLabel?.text = viewModel.title
        titleLabel?.font = .compactDisplay(withStyle: .medium, size: 16)
        stackViewLeadingConstraint?.constant = viewModel.leadingConstraint

        if let date = viewModel.date { datePicker?.setDate(date, animated: true) }
        if let minimumDate = viewModel.minimumDate { datePicker?.minimumDate = minimumDate}
        if let maximumDate = viewModel.maximumDate { datePicker?.maximumDate = maximumDate }

        delegate = viewModel.delegate
    }

    // MARK: - Private Methods

    private func setupViews() {
        datePicker?.layer.cornerRadius = 6
        datePicker?.clipsToBounds = true
        datePicker?.backgroundColor = .background6?.withAlphaComponent(0.5)
    }

    @IBAction private func didSelectDate(_ sender: UIDatePicker) {
        delegate?.didSelectDate(date: sender.date)
    }
}
