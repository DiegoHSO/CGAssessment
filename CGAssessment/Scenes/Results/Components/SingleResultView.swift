//
//  SingleResultView.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import UIKit

class SingleResultView: UIView {

    // MARK: - Private Properties

    @IBOutlet private var contentView: UIView?
    @IBOutlet private weak var resultTitleLabel: UILabel?
    @IBOutlet private weak var resultDescriptionLabel: UILabel?

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
        Bundle.main.loadNibNamed("SingleResultView", owner: self, options: nil)
        addSubview(contentView ?? UIView())
        contentView?.frame = self.bounds
        contentView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    // MARK: - Public Methods

    func setup(title: String, description: String) {
        resultTitleLabel?.text = title.uppercased()
        resultDescriptionLabel?.text = description
    }
}
