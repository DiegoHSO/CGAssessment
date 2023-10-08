//
//  GroupedButtonView.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import UIKit

protocol GroupedButtonDelegate: AnyObject {
    func didSelect(buttonIdentifier: LocalizedTable)
}

class GroupedButtonView: UIView {

    // MARK: - Private Properites

    @IBOutlet private var contentView: UIView?
    @IBOutlet private weak var groupedButton: UIButton?
    private var delegate: GroupedButtonDelegate?
    private var buttonIdentifier: LocalizedTable?

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
        Bundle.main.loadNibNamed("GroupedButtonView", owner: self, options: nil)
        addSubview(contentView ?? UIView())
        contentView?.frame = self.bounds
        contentView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setupViews()
    }

    // MARK: - Public Methods

    func setup(title: LocalizedTable, symbolName: String, delegate: GroupedButtonDelegate?) {
        groupedButton?.setTitle(title.localized, for: .normal)
        groupedButton?.setImage(UIImage(named: symbolName), for: .normal)

        self.buttonIdentifier = title
        self.delegate = delegate
    }

    // MARK: - Private Methods

    private func setupViews() {
        groupedButton?.titleLabel?.font = .compactDisplay(withStyle: .semibold, size: 16)
        groupedButton?.layer.borderColor = UIColor.label1?.cgColor
        groupedButton?.layer.borderWidth = 1
    }

    @IBAction private func groupedButtonAction(_ sender: UIButton) {
        guard let buttonIdentifier else { return }
        delegate?.didSelect(buttonIdentifier: buttonIdentifier)
    }

}
