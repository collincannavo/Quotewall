//
//  SharedQuoteCollectionViewCell.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/29/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import UIKit


class SharedQuoteCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        sharedQuoteView.layer.cornerRadius = 12
        sharedQuoteView.clipsToBounds = true
    }
    
    var sharedQuote: SharedQuote? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var sharedQuoteView: UIView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    fileprivate func updateViews() {
        
        authorLabel.text = sharedQuote?.name
        quoteLabel.text = sharedQuote?.quote
        
        
    }
    
    
}

