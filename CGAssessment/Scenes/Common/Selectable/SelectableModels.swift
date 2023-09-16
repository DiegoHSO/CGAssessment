//
//  SelectableModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 14/09/23.
//

import Foundation

struct SelectableModels {

    struct QuestionsViewModel {
        let title: String?
        let questions: Questions
        let delegate: SelectableViewDelegate?
        let selectedQuestion: SelectableKeys
    }

    struct ComponentViewModel {
        let text: String
        let identifier: SelectableKeys
        let delegate: SelectableViewDelegate?
        let isSelected: Bool
    }
}
