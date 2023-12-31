//
//  ResumedPatientTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 16/09/23.
//

import UIKit

protocol ResumedPatientDelegate: AnyObject {
    func didSelect(patientId: UUID)
}

class ResumedPatientTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var componentView: UIView?
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var ageLabel: UILabel?
    @IBOutlet private weak var genderImageView: UIImageView?
    @IBOutlet private weak var viewLeadingConstraint: NSLayoutConstraint?
    private weak var delegate: ResumedPatientDelegate?
    private var patientId: UUID?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupGesture()
    }

    // MARK: - Public Methods

    func setup(viewModel: NewCGAModels.ResumedPatientViewModel, isSelected: Bool) {
        ageLabel?.text = "\(viewModel.patient.patientAge) \(LocalizedTable.age.localized)"
        ageLabel?.font = .compactDisplay(withStyle: .semibold, size: 15)
        genderImageView?.image = viewModel.patient.gender.image
        viewLeadingConstraint?.constant = viewModel.leadingConstraint

        patientId = viewModel.id
        delegate = viewModel.delegate
        self.isSelected = isSelected

        setupSelection()

        nameLabel?.text = viewModel.patient.patientName
        nameLabel?.font = .compactDisplay(withStyle: .semibold, size: 20)
    }

    // MARK: - Private Methods

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapComponent))
        componentView?.addGestureRecognizer(tapGesture)
    }

    private func setupSelection() {
        if isSelected {
            componentView?.layer.borderWidth = 4
            componentView?.layer.borderColor = UIColor.label1?.withAlphaComponent(0.7).cgColor
        } else {
            componentView?.layer.borderWidth = 0
        }

        layoutIfNeeded()
    }

    @objc private func didTapComponent() {
        guard let patientId else { return }
        delegate?.didSelect(patientId: patientId)
    }
}
