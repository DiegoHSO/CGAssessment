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
    
    // MARK: - Public Methods
    
    func setup(image: UIImage?) {
        guard let image else { return }
        customImageView?.image = image.generateImageWithBorder(borderSize: 75)
    }
    
}
