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
            return UIImage(named: "man")
        case .female:
            return UIImage(named: "woman")
        }
    }
}

struct CGAModels {

    /*
     typealias Tabs = (
     home: UIViewController?,
     cgas: UIViewController?,
     preferences: UIViewController?
     )
     */

    typealias Tabs = (
        home: UIViewController?,
        cgas: UIViewController?
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

    struct StatusViewModel {
        let patientName: String?
        let patientBirthDate: Date?
        let cgaCreationDate: Date
        let cgaLastModifiedDate: Date
    }

    struct Instruction {
        let number: Int
        let description: String
    }

    struct GroupedButtonViewModel {
        let title: LocalizedTable
        let symbolName: String
        let delegate: GroupedButtonDelegate?
    }

    struct SheetableViewModel {
        let title: String?
        let pickerName: LocalizedTable?
        let pickerValue: String?
        let delegate: SheetableDelegate?
        var horizontalConstraint: CGFloat = 25
    }

    struct BottomSheetViewModel {
        let pickerContent: [String]
        let identifier: LocalizedTable?
        let delegate: PickerViewDelegate?
        let selectedRow: Int
    }

    enum FilterOptions {
        case recent
        case older
        case byPatient
        case aToZ
        case zToA
        case olderAge
        case youngerAge

        var title: String? {
            switch self {
            case .recent:
                return LocalizedTable.recent.localized
            case .older:
                return LocalizedTable.older.localized
            case .byPatient:
                return LocalizedTable.byPatient.localized
            case .aToZ:
                return LocalizedTable.aToZ.localized
            case .zToA:
                return LocalizedTable.zToA.localized
            case .olderAge:
                return LocalizedTable.olderAge.localized
            case .youngerAge:
                return LocalizedTable.youngerAge.localized
            }
        }
    }

    enum BorderType {
        case image
        case imageView
        case none
    }

}
