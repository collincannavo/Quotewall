//
//  FavoriteQuoteCollectionViewCell.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/24/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import UIKit

class FavoriteQuoteCollectionViewCell: UICollectionViewCell {
    
    
    var favoriteQuote: FavoriteQuote? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var favoriteQuoteView: UIView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    fileprivate func updateViews() {
        
        authorLabel.text = favoriteQuote?.name
        quoteLabel.text = favoriteQuote?.quote
        
    }
    
    
}
