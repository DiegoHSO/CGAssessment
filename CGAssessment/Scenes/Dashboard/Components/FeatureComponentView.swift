//
//  FeatureComponentView.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 06/09/23.
//

import UIKit

protocol FeatureComponentDelegate: AnyObject {
    func didTapComponent(identifier: DashboardModels.MenuOption)
}

class FeatureComponentView: UIView {

    // MARK: - Private Properties

    @IBOutlet private var contentView: UIView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var iconLabel: UILabel?
    private var componentIdentifier: DashboardModels.MenuOption?
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

    func setup(title: String, iconSymbol: String, identifier: DashboardModels.MenuOption,
               delegate: FeatureComponentDelegate?, isEnabled: Bool = true,
               accessibilityIdentifier: String) {
        titleLabel?.text = title
        titleLabel?.font = .compactDisplay(withStyle: .semibold, size: 20)
        iconLabel?.text = iconSymbol
        iconLabel?.font = .compactDisplay(withStyle: .medium, size: 18)
        componentIdentifier = identifier
        contentView?.accessibilityIdentifier = accessibilityIdentifier
        self.delegate = delegate

        if !isEnabled {
            contentView?.backgroundColor = .opaqueSeparator
            titleLabel?.textColor = .label9
            iconLabel?.textColor = .label9
        }
    }

    // MARK: - Private Methods

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapComponent))
        addGestureRecognizer(tapGesture)
    }

    @objc private func didTapComponent() {
        guard let componentIdentifier else { return }
        delegate?.didTapComponent(identifier: componentIdentifier)
    }
}
