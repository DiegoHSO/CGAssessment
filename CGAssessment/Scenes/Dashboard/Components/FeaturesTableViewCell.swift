//
//  FeaturesTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 10/09/23.
//

import UIKit

class FeaturesTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var firstComponentView: FeatureComponentView?
    @IBOutlet private weak var secondComponentView: FeatureComponentView?
    @IBOutlet private weak var thirdComponentView: FeatureComponentView?
    @IBOutlet private weak var fourthComponentView: FeatureComponentView?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    // MARK: - Public Methods

    func setupFirstComponent(title: String, iconSymbol: String, identifier: DashboardModels.MenuOption, delegate: FeatureComponentDelegate?) {
        firstComponentView?.setup(title: title, iconSymbol: iconSymbol, identifier: identifier, delegate: delegate)
    }

    func setupSecondComponent(title: String, iconSymbol: String, identifier: DashboardModels.MenuOption, delegate: FeatureComponentDelegate?) {
        secondComponentView?.setup(title: title, iconSymbol: iconSymbol, identifier: identifier, delegate: delegate)
    }

    func setupThirdComponent(title: String, iconSymbol: String, identifier: DashboardModels.MenuOption, delegate: FeatureComponentDelegate?) {
        thirdComponentView?.setup(title: title, iconSymbol: iconSymbol, identifier: identifier, delegate: delegate)
    }

    func setupFourthComponent(title: String, iconSymbol: String, identifier: DashboardModels.MenuOption, delegate: FeatureComponentDelegate?) {
        fourthComponentView?.setup(title: title, iconSymbol: iconSymbol, identifier: identifier, delegate: delegate)
    }
}
