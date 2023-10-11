//
//  ImageTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 25/09/23.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var customImageView: UIImageView?
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint?
    @IBOutlet private weak var progressView: UIProgressView?
    @IBOutlet private weak var aspectRatioConstraint: NSLayoutConstraint!

    // MARK: - Public Methods

    func setup(image: UIImage?, bottomConstraint: CGFloat = 20, multiplier: CGFloat = 0.75, progress: Progress? = nil, borderType: CGAModels.BorderType = .image) {
        if let image {
            switch borderType {
            case .image:
                customImageView?.image = image.generateImageWithBorder(borderSize: 75)
                customImageView?.layer.borderColor = UIColor.clear.cgColor
            case .imageView:
                customImageView?.image = image
                customImageView?.layer.borderColor = UIColor.label3?.cgColor
                customImageView?.layer.borderWidth = 1
                customImageView?.layer.cornerRadius = 10
            case .none:
                customImageView?.image = image
            }

            customImageView?.isHidden = false
            progressView?.isHidden = true
        } else if let progress {
            customImageView?.isHidden = true
            progressView?.isHidden = false
            progressView?.observedProgress = progress
        }

        self.bottomConstraint?.constant = bottomConstraint

        if multiplier != aspectRatioConstraint.multiplier {
            let newConstraint = aspectRatioConstraint.constraintWithMultiplier(multiplier)
            customImageView?.removeConstraint(aspectRatioConstraint)
            customImageView?.addConstraint(newConstraint)
            layoutIfNeeded()
            aspectRatioConstraint = newConstraint
        }
    }

}
