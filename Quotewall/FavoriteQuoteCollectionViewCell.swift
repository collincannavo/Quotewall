//
//  FavoriteQuoteCollectionViewCell.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/24/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import UIKit

class FavoriteQuoteCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        favoriteQuoteView.layer.cornerRadius = 12
        favoriteQuoteView.clipsToBounds = true
    }
    
    var favoriteQuote: FavoriteQuote? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var favoriteQuoteView: UIView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    fileprivate func updateViews() {
        
        authorLabel.text = favoriteQuote?.name
        quoteLabel.text = favoriteQuote?.quote
        
        
        
    }
    
    
}
