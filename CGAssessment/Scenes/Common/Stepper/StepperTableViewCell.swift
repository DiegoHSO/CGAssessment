//
//  StepperTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import UIKit

protocol StepperDelegate: AnyObject {
    func didChangeValue(value: Int)
}

class StepperTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var stepperValueLabel: UILabel?
    @IBOutlet private weak var stepper: UIStepper?
    @IBOutlet private weak var stackleadingConstraint: NSLayoutConstraint?
    private weak var delegate: StepperDelegate?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    // MARK: - Public Methods

    func setup(title: String?, value: Int, delegate: StepperDelegate?, leadingConstraint: CGFloat = 30) {
        titleLabel?.text = title
        titleLabel?.isHidden = title == nil
        stepperValueLabel?.text = String(value)
        stepper?.value = Double(value)
        stackleadingConstraint?.constant = leadingConstraint

        self.delegate = delegate
    }

    // MARK: - Private Methods

    private func setupViews() {
        titleLabel?.font = .compactDisplay(withStyle: .medium, size: 16)
        stepperValueLabel?.font = .compactDisplay(withStyle: .bold, size: 20)
    }

    @IBAction private func didChangeStepperValue(_ sender: UIStepper) {
        stepperValueLabel?.text = String(Int(sender.value))
        delegate?.didChangeValue(value: Int(sender.value))
    }
}
