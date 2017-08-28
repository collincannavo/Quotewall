//
//  QuotesCollectionViewCell.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/19/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import UIKit

class QuotesCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        quoteOutlineView.layer.cornerRadius = 12
        quoteOutlineView.clipsToBounds = true
    }
    
    var quote: Quote? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var quoteOutlineView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var quoteTextLabel: UILabel!

    func updateViews() {
        
//        backgroundImage.image = quote?.image
        authorNameLabel.text = quote?.name
        quoteTextLabel.text = quote?.text
        quoteOutlineView.layer.cornerRadius = 40.0
        
    }
    
}


