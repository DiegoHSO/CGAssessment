//
//  BinaryOptionView.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 05/10/23.
//

import UIKit

protocol BinaryOptionDelegate: AnyObject {
    func didSelect(option: SelectableBinaryOption, identifier: Int)
}

class BinaryOptionView: UIView {

    // MARK: - Private Properites

    @IBOutlet private var contentView: UIView?
    @IBOutlet private weak var labelOptionsStackView: UIStackView?
    @IBOutlet private weak var firstOptionTitleLabel: UILabel?
    @IBOutlet private weak var secondOptionTitleLabel: UILabel?
    @IBOutlet private weak var questionLabel: UILabel?
    @IBOutlet private weak var yesOptionButton: UIButton?
    @IBOutlet private weak var noOptionButton: UIButton?
    private var delegate: BinaryOptionDelegate?
    private var identifier: Int?
    private var selectedOption: SelectableBinaryOption {
        if yesOptionButton?.isSelected ?? false {
            return .yes
        } else if noOptionButton?.isSelected ?? false {
            return .not
        } else {
            return .none
        }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("BinaryOptionView", owner: self, options: nil)
        addSubview(contentView ?? UIView())
        contentView?.frame = self.bounds
        contentView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setupViews()
    }

    // MARK: - Public Methods

    func setup(viewModel: BinaryOptionsModels.BinaryOptionViewModel) {
        questionLabel?.text = viewModel.question
        firstOptionTitleLabel?.text = viewModel.firstOptionTitle
        secondOptionTitleLabel?.text = viewModel.secondOptionTitle
        labelOptionsStackView?.isHidden = viewModel.firstOptionTitle == nil && viewModel.secondOptionTitle == nil
        delegate = viewModel.delegate
        identifier = viewModel.identifier
    }

    // MARK: - Private Methods

    private func setupViews() {
        questionLabel?.font = .compactDisplay(withStyle: .regular, size: 15)
        firstOptionTitleLabel?.font = .compactDisplay(withStyle: .medium, size: 16)
        secondOptionTitleLabel?.font = .compactDisplay(withStyle: .medium, size: 16)

        yesOptionButton?.setImage(.BinaryOptions.yesSelected, for: .selected)
        yesOptionButton?.setImage(.BinaryOptions.noneSelected, for: .normal)
        noOptionButton?.setImage(.BinaryOptions.noSelected, for: .selected)
        noOptionButton?.setImage(.BinaryOptions.noneSelected, for: .normal)
    }

    @IBAction private func yesOptionAction(_ sender: UIButton) {
        guard let identifier else { return }
        yesOptionButton?.isSelected = true
        noOptionButton?.isSelected = false
        delegate?.didSelect(option: selectedOption, identifier: identifier)
    }

    @IBAction private func noOptionAction(_ sender: UIButton) {
        guard let identifier else { return }
        noOptionButton?.isSelected = true
        yesOptionButton?.isSelected = false
        delegate?.didSelect(option: selectedOption, identifier: identifier)
    }
}
