//
//  SelectableModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 14/09/23.
//

import UIKit

struct SelectableModels {

    struct OptionsViewModel {
        let title: String?
        let options: Options
        let delegate: SelectableViewDelegate?
        let selectedQuestion: SelectableKeys
        var leadingConstraint: CGFloat = 30
        var textStyle: Style = .regular
    }

    struct ComponentViewModel {
        let textKey: LocalizedTable
        let identifier: SelectableKeys
        let delegate: SelectableViewDelegate?
        let isSelected: Bool
        let textStyle: Style
    }

}
