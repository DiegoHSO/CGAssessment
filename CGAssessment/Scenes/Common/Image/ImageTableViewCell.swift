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

    // MARK: - Public Methods

    func setup(image: UIImage?, bottomConstraint: CGFloat = 20) {
        guard let image else { return }
        customImageView?.image = image.generateImageWithBorder(borderSize: 75)
        self.bottomConstraint?.constant = bottomConstraint
    }

}
