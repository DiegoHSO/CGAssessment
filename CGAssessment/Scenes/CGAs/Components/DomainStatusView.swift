//
//  DomainStatusView.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 01/10/23.
//

import UIKit

class DomainStatusView: UIView {

    // MARK: - Private Properties

    @IBOutlet private var contentView: UIView?
    @IBOutlet private weak var domainNameLabel: UILabel?
    @IBOutlet private weak var domainStatusSymbolLabel: UILabel?

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
        Bundle.main.loadNibNamed("DomainStatusView", owner: self, options: nil)
        addSubview(contentView ?? UIView())
        contentView?.frame = self.bounds
        contentView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setupLabels()
    }

    // MARK: - Public Methods

    func setup(domainName: String, status: CGAsModels.CompletionStatus) {
        domainNameLabel?.text = domainName
        domainNameLabel?.textColor = status.color
        domainStatusSymbolLabel?.text = status.symbol
        domainStatusSymbolLabel?.textColor = status.color
    }

    // MARK: - Private Methods

    private func setupLabels() {
        domainNameLabel?.font = .compactDisplay(withStyle: .semibold, size: 13)
        domainStatusSymbolLabel?.font = .compactDisplay(withStyle: .semibold, size: 15)
    }

}
