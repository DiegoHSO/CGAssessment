//
//  UIImage+Extension.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/09/23.
//

import UIKit

extension UIImage {

    typealias ImageAndColor = (image: UIImage?, color: UIColor?)

    struct TabBar {
        private static let symbolConfiguration: SymbolConfiguration = .init(font: UIFont(name: "SFCompactDisplay-Medium", size: 18) ??
                                                                                .systemFont(ofSize: 18), scale: .default)

        static var dashboardNormal: UIImage? {
            UIImage(systemName: "house")?
                .withTintColor(.label8 ?? .clear, renderingMode: .alwaysOriginal)
                .applyingSymbolConfiguration(symbolConfiguration)
        }

        static var dashboardSelected: UIImage? {
            UIImage(systemName: "house.fill")?
                .withTintColor(.label7 ?? .clear, renderingMode: .alwaysOriginal)
                .applyingSymbolConfiguration(symbolConfiguration)
        }

        static var cgasNormal: UIImage? {
            UIImage(systemName: "staroflife")?
                .withTintColor(.label8 ?? .clear, renderingMode: .alwaysOriginal)
                .applyingSymbolConfiguration(symbolConfiguration)
        }

        static var cgasSelected: UIImage? {
            UIImage(systemName: "staroflife.fill")?
                .withTintColor(.label7 ?? .clear, renderingMode: .alwaysOriginal)
                .applyingSymbolConfiguration(symbolConfiguration)
        }

        static var preferencesNormal: UIImage? {
            UIImage(systemName: "gearshape")?
                .withTintColor(.label8 ?? .clear, renderingMode: .alwaysOriginal)
                .applyingSymbolConfiguration(symbolConfiguration)
        }

        static var preferencesSelected: UIImage? { UIImage(systemName: "gearshape.fill")?
            .withTintColor(.label7 ?? .clear, renderingMode: .alwaysOriginal)
            .applyingSymbolConfiguration(symbolConfiguration)
        }
    }
}
