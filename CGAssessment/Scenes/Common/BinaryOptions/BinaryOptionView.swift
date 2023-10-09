//
//  BinaryOptionView.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 05/10/23.
//

import UIKit

protocol BinaryOptionDelegate: AnyObject {
    func didSelect(option: SelectableBinaryKeys, numberIdentifier: Int16, sectionIdentifier: LocalizedTable)
}

class BinaryOptionView: UIView {

    // MARK: - Private Properites

    @IBOutlet private var contentView: UIView?
    @IBOutlet private weak var firstOptionTitleLabel: UILabel?
    @IBOutlet private weak var secondOptionTitleLabel: UILabel?
    @IBOutlet private weak var questionLabel: UILabel?
    @IBOutlet private weak var yesOptionButton: UIButton?
    @IBOutlet private weak var noOptionButton: UIButton?
    private var delegate: BinaryOptionDelegate?
    private var numberIdentifier: Int16?
    private var sectionIdentifier: LocalizedTable?
    private var selectedOption: SelectableBinaryKeys = .none

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
        questionLabel?.text = viewModel.question.localized
        firstOptionTitleLabel?.text = viewModel.firstOptionTitle
        secondOptionTitleLabel?.text = viewModel.secondOptionTitle
        delegate = viewModel.delegate
        numberIdentifier = viewModel.identifier
        sectionIdentifier = viewModel.sectionIdentifier
        selectedOption = viewModel.selectedOption
        updateButtons()
    }

    // MARK: - Private Methods

    private func setupViews() {
        questionLabel?.font = .compactDisplay(withStyle: .regular, size: 15)
        firstOptionTitleLabel?.font = .compactDisplay(withStyle: .medium, size: 16)
        secondOptionTitleLabel?.font = .compactDisplay(withStyle: .medium, size: 16)
    }

    private func updateButtons() {
        if selectedOption == .yes {
            yesOptionButton?.setImage(.BinaryOptions.yesSelected, for: .normal)
            noOptionButton?.setImage(.BinaryOptions.noneSelected, for: .normal)
        } else if selectedOption == .not {
            noOptionButton?.setImage(.BinaryOptions.noSelected, for: .normal)
            yesOptionButton?.setImage(.BinaryOptions.noneSelected, for: .normal)
        } else {
            yesOptionButton?.setImage(.BinaryOptions.noneSelected, for: .normal)
            noOptionButton?.setImage(.BinaryOptions.noneSelected, for: .normal)
        }
    }

    @IBAction private func yesOptionAction(_ sender: UIButton) {
        guard let numberIdentifier, let sectionIdentifier, selectedOption != .yes else { return }
        selectedOption = .yes
        updateButtons()
        delegate?.didSelect(option: selectedOption, numberIdentifier: numberIdentifier, sectionIdentifier: sectionIdentifier)
    }

    @IBAction private func noOptionAction(_ sender: UIButton) {
        guard let numberIdentifier, let sectionIdentifier, selectedOption != .not else { return }
        selectedOption = .not
        updateButtons()
        delegate?.didSelect(option: selectedOption, numberIdentifier: numberIdentifier, sectionIdentifier: sectionIdentifier)
    }
}
