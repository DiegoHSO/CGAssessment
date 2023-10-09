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

    // MARK: - Public Methods

    func setup(image: UIImage?, bottomConstraint: CGFloat = 20, progress: Progress? = nil, borderInImage: Bool = true) {
        if let image {
            if borderInImage {
                customImageView?.image = image.generateImageWithBorder(borderSize: 75)
                customImageView?.layer.borderColor = UIColor.clear.cgColor
            } else {
                customImageView?.image = image
                customImageView?.layer.borderColor = UIColor.label3?.cgColor
                customImageView?.layer.borderWidth = 1
                customImageView?.layer.cornerRadius = 10
            }

            customImageView?.isHidden = false
            progressView?.isHidden = true
        } else if let progress {
            customImageView?.isHidden = true
            progressView?.isHidden = false
            progressView?.observedProgress = progress
        }

        self.bottomConstraint?.constant = bottomConstraint
    }

}
