//
//  UIImage+Extension.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/09/23.
//

import UIKit

extension UIImage {

    func generateImageWithBorder(borderSize borderWidth: CGFloat = 10.0) -> UIImage {
        let size = self.size
        let rect = CGRect(origin: .zero, size: size)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: borderWidth)
        let renderer = UIGraphicsImageRenderer(size: size)

        let firstImg = renderer.image { ctx in
            self.draw(in: rect)
            ctx.cgContext.setStrokeColor((UIColor.label3 ?? .clear).cgColor)
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.addRect(rect)
            ctx.cgContext.drawPath(using: .stroke)
        }

        let finalImg = renderer.image { _ in
            UIColor.label3?.setStroke()
            path.lineWidth = 10
            path.stroke()
            path.addClip()
            firstImg.draw(in: rect)
        }

        return finalImg
    }

    typealias ImageAndColor = (image: UIImage?, color: UIColor?)

    struct BinaryOptions {
        static var yesSelected: UIImage? { UIImage(systemName: "checkmark.circle.fill")?
            .withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        }

        static var noSelected: UIImage? { UIImage(systemName: "xmark.circle.fill")?
            .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        }

        static var noneSelected: UIImage? { UIImage(systemName: "circle")?
            .withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
        }
    }

    struct TabBar {
        private static let symbolConfiguration: SymbolConfiguration = .init(font: .compactDisplay(withStyle: .medium, size: 18),
                                                                            scale: .default)

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
