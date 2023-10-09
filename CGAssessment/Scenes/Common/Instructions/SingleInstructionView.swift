//
//  SingleInstructionView.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 23/09/23.
//

import UIKit

class SingleInstructionView: UIView {

    // MARK: - Private Properties

    @IBOutlet private var contentView: UIView?
    @IBOutlet private weak var instructionNumberLabel: UILabel?
    @IBOutlet private weak var instructionLabel: UILabel?

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
        Bundle.main.loadNibNamed("SingleInstructionView", owner: self, options: nil)
        addSubview(contentView ?? UIView())
        contentView?.frame = self.bounds
        contentView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    // MARK: - Public Methods

    func setup(number: Int, description: String) {
        instructionNumberLabel?.text = String(number) + "."
        instructionNumberLabel?.font = .compactDisplay(withStyle: .medium, size: 16)
        instructionLabel?.text = description
        instructionLabel?.font = .compactDisplay(withStyle: .medium, size: 16)
    }
}
