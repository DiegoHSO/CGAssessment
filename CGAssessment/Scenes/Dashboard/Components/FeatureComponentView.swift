//
//  FeatureComponentView.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 06/09/23.
//

import UIKit

protocol FeatureComponentDelegate: AnyObject {
    func didTapComponent(identifier: String) // TODO: Change type
}

class FeatureComponentView: UIView {

    // MARK: - Private Properties

    @IBOutlet private var contentView: UIView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var iconLabel: UILabel?
    private var componentIdentifier: String = ""
    private weak var delegate: FeatureComponentDelegate?

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
        setupGesture()
    }

    // MARK: - Public Methods

    func setup(title: String, iconSymbol: String, identifier: String, delegate: FeatureComponentDelegate?) {
        titleLabel?.text = title
        iconLabel?.text = iconSymbol
        componentIdentifier = identifier
        self.delegate = delegate
    }

    // MARK: - Private Methods

    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapComponent))
        addGestureRecognizer(tapGesture)
    }

    @objc func didTapComponent() {
        delegate?.didTapComponent(identifier: componentIdentifier)
    }
}
