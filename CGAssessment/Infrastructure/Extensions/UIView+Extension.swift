//
//  UIView+Extension.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 09/09/23.
//

import UIKit

extension UIView {
    /// Get the name of the class. Use this for easy reusable nib name
    static var className: String { String(describing: Self.self) }

    /// Tap gesture to dismiss keyboard when tapped around the screen
    @objc func dismissKeyboard() {
        endEditing(true)
    }

    func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
}
