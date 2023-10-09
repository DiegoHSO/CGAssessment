//
//  TestNameView.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 20/09/23.
//

import UIKit

class TestNameView: UIView {

    // MARK: - Private Properties

    @IBOutlet private var contentView: UIView?
    @IBOutlet private weak var testNameLabel: UILabel?
    @IBOutlet private weak var isTestDoneLabel: UILabel?

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
        Bundle.main.loadNibNamed("TestNameView", owner: self, options: nil)
        addSubview(contentView ?? UIView())
        contentView?.frame = self.bounds
        contentView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    // MARK: - Public Methods

    func setup(testName: String, isDone: Bool) {
        testNameLabel?.text = testName
        isTestDoneLabel?.isHidden = !isDone
    }

}
