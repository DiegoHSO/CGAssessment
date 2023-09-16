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
    private weak var delegate: DatePickerDelegate?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    // MARK: - Public Methods

    func setup(title: String?, date: Date?, minimumDate: Date?, maximumDate: Date?, delegate: DatePickerDelegate?) {
        titleLabel?.text = title

        if let date { datePicker?.setDate(date, animated: true) }
        if let minimumDate { datePicker?.minimumDate = minimumDate}
        if let maximumDate { datePicker?.maximumDate = maximumDate }

        self.delegate = delegate
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
