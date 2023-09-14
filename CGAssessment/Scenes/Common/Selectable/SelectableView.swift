//
//  SelectableView.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 14/09/23.
//

import UIKit

protocol SelectableViewDelegate: AnyObject {
    func didSelect(option: SelectableKeys)
}

class SelectableView: UIView {

    // MARK: - Private Properties

    @IBOutlet private var contentView: UIView?
    @IBOutlet private weak var circleView: UIView?
    @IBOutlet private weak var innerCircleView: UIView?
    @IBOutlet private weak var textLabel: UILabel?
    private var componentIdentifier: SelectableKeys?
    private var isSelected: Bool = false
    private weak var delegate: SelectableViewDelegate?

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
        Bundle.main.loadNibNamed("SelectableView", owner: self, options: nil)
        addSubview(contentView ?? UIView())
        contentView?.frame = self.bounds
        contentView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setupViews()
    }

    // MARK: - Public Methods

    func setup(viewModel: SelectableModels.ViewModel) {
        componentIdentifier = viewModel.identifier
        delegate = viewModel.delegate
        isSelected = viewModel.isSelected

        textLabel?.text = viewModel.text
        innerCircleView?.isHidden = !viewModel.isSelected
    }

    // MARK: - Private Methods

    func setupViews() {
        circleView?.layer.borderWidth = 1
        circleView?.layer.borderColor = UIColor.label1?.cgColor
        circleView?.layer.cornerRadius = (circleView?.frame.size.width) ?? 0 / 2
        innerCircleView?.layer.cornerRadius = (innerCircleView?.frame.size.width) ?? 0 / 2
        innerCircleView?.isHidden = !isSelected
    }

    @IBAction private func didTapComponent(_ sender: UIButton) {
        if let componentIdentifier, !isSelected {
            innerCircleView?.isHidden = false
            delegate?.didSelect(option: componentIdentifier)
        }
    }
}
