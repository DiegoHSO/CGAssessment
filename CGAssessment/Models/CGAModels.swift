//
//  CGAs.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 14/09/23.
//

import UIKit

typealias Options = [SelectableKeys: LocalizedTable]

enum Gender: String {
    case male = "man"
    case female = "woman"
}

struct CGAModels {

    typealias Tabs = (
        home: UIViewController?,
        cgas: UIViewController?,
        preferences: UIViewController?
    )

    struct DatePickerViewModel {
        let title: String?
        let date: Date?
        let minimumDate: Date?
        let maximumDate: Date?
        let delegate: DatePickerDelegate?
        var leadingConstraint: CGFloat = 30
    }

    struct TextFieldViewModel {
        let title: String?
        let text: String?
        let placeholder: String?
        let delegate: TextFieldDelegate?
        var leadingConstraint: CGFloat = 30
    }

    struct InstructionsViewModel {
        let instructions: [Instruction]
    }

    struct Instruction {
        let number: Int
        let description: String
    }

}
