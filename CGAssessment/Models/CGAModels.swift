//
//  CGAs.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 14/09/23.
//

import UIKit

typealias Options = [SelectableKeys: LocalizedTable]

@objc
public enum Gender: Int16, CaseIterable {
    case male
    case female

    var image: UIImage? {
        switch self {
        case .male:
            return UIImage(named: "male")
        case .female:
            return UIImage(named: "female")
        }
    }
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
        var keyboardType: UIKeyboardType = .asciiCapable
        var identifier: LocalizedTable?
    }

    struct InstructionsViewModel {
        let instructions: [Instruction]
    }

    struct Instruction {
        let number: Int
        let description: String
    }

}
