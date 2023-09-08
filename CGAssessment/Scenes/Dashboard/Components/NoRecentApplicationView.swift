//
//  NoRecentApplicationView.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 08/09/23.
//

import UIKit

protocol NoRecentApplicationDelegate: AnyObject {
    func didTapCallToAction()
}

class NoRecentApplicationView: UIView {

    // MARK: - Private Properties

    @IBOutlet private var contentView: UIView?
    @IBOutlet private weak var noRegisteredApplications: UILabel?
    @IBOutlet private weak var callToActionLabel: UILabel?
    @IBOutlet private weak var callToActionButton: UIButton?
    weak var delegate: NoRecentApplicationDelegate?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupLabels()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setupLabels()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("NoRecentApplicationView", owner: self, options: nil)
        addSubview(contentView ?? UIView())
        contentView?.frame = self.bounds
        contentView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        callToActionButton?.layer.borderColor = UIColor(named: "Label-3")?.withAlphaComponent(0.5).cgColor
        callToActionButton?.layer.borderWidth = 2
    }

    // MARK: - Private Methods

    @IBAction private func callToAction(_ sender: UIButton) {
        delegate?.didTapCallToAction()
    }

    private func setupLabels() {
        noRegisteredApplications?.text = LocalizedTable.Dashboard.noRegisteredApplications.localized
        callToActionLabel?.text = LocalizedTable.Dashboard.beginFirstCGA.localized
        callToActionButton?.setTitle(LocalizedTable.Dashboard.seeCGAExample.localized, for: .normal)
    }
}
