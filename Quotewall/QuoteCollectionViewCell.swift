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
    @IBOutlet weak var authorNameLabel: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroundImageButton: UIButton!
   
    var quote: Quote?
    
    @IBAction func backgroundImageButtonTapped(_ sender: Any) {
        guard let buttonTapped = sender as? UIButton else { return }
            delegate?.photoSelectCellSelected(backgroundImageButtonTapped: buttonTapped)
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
    }
    
    public func updateViews() {
        guard let quote = quote
            
        else { return }
        
        authorNameLabel.text = quote.name
        quoteTextField.text = quote.text
        
        if let data = quote.image,
            let newImage = UIImage(data: data) {
            backgroundImageButton.setTitle("", for: .normal)
            backgroundImage.image = newImage
            backgroundImage.contentMode = .scaleAspectFit
        }
    }

}

// MARK: - Delegate properties

public weak var delegate: PhotoSelectorCellDelegate?



// MARK: - Protocol

@objc public protocol PhotoSelectorCellDelegate: class, NSObjectProtocol {
    @objc optional func photoSelectCellSelected(backgroundImageButtonTapped: UIButton)
    
}

