//
//  QuoteCollectionViewCell.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/17/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import UIKit

class QuoteCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var quoteTextField: UITextView!
    @IBOutlet weak var closeQuotationImage: UIImageView!
    @IBOutlet weak var openQuotationImage: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroundImageButton: UIButton!
   
    var quote: Quote?
    
    @IBAction func backgroundImageButtonTapped(_ sender: Any) {
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

// MARK: - Delegate properties

public weak var delegate: PhotoSelectorCellDelegate?



// MARK: - Protocol

@objc public protocol PhotoSelectorCellDelegate: class, NSObjectProtocol {
    @objc optional func photoSelectCellSelected(backgroundImageButtonTapped: UIButton)
    
}

