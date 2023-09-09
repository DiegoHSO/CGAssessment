//
//  FeatureComponentView.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 06/09/23.
//

import UIKit

class FeatureComponentView: UIView {

    // MARK: - Private Properties

    @IBOutlet var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var iconLabel: UILabel?

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
        Bundle.main.loadNibNamed("FeatureComponentView", owner: self, options: nil)
        addSubview(contentView ?? UIView())
        contentView?.frame = self.bounds
        contentView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    // MARK: - Public Methods

    func setup(title: String, iconSymbol: String) {
        titleLabel?.text = title
        iconLabel?.text = iconSymbol
    }
}
