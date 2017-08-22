//
//  QuotesCollectionViewCell.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/19/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import UIKit

class QuotesCollectionViewCell: UICollectionViewCell {
    
    var quote: Quote? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var quoteTextLabel: UILabel!

    func updateViews() {
        
//        backgroundImage.image = quote?.image
        authorNameLabel.text = quote?.name
        quoteTextLabel.text = quote?.text
    }
    
    



}
