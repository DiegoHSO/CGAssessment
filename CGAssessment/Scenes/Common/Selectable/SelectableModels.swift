//
//  SelectableModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 14/09/23.
//

import UIKit

struct SelectableModels {

    struct OptionsViewModel {
        let title: LocalizedTable?
        let options: Options
        let delegate: SelectableViewDelegate?
        let selectedQuestion: SelectableKeys
        var questionsSpacing: CGFloat = 10
        var leadingConstraint: CGFloat = 30
        var textStyle: Style = .regular
    }

    struct ComponentViewModel {
        let text: String
        let contextIdentifier: LocalizedTable
        let componentIdentifier: SelectableKeys
        let delegate: SelectableViewDelegate?
        let isSelected: Bool
        let textStyle: Style
    }

}
