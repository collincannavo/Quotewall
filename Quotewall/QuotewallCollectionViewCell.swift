//
//  QuotewallCollectionViewCell.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/17/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import UIKit

class QuotewallCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryBackgroundImage: UIImageView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    
    public var quotewall: Quotewall?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
    }

   public func updateViews() {
        
        if let data = quotewall?.backgroundImage,
            let image = UIImage(data: data) {
            categoryBackgroundImage.image = image
            categoryBackgroundImage.contentMode = .scaleAspectFit
        }
        
        
    }
    
    
    
}



// MARK: - Delegate

public weak var categoryDelegate: CategoryPhotoSelectorCellDelegate?

@objc public protocol CategoryPhotoSelectorCellDelegate: class, NSObjectProtocol {
    @objc optional func categoryPhotoSelectCellSelected(backgroundImageButtonTapped: UIAlertAction)
    
}
