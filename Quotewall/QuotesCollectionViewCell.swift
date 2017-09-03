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
        
        quoteCardView.layer.shadowOpacity = 1.0
        quoteCardView.layer.shadowRadius = 4
        quoteCardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        quoteCardView.layer.shadowColor = UIColor.black.cgColor
    }
    
    @IBOutlet weak var quoteOutlineView: UIView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var quoteTextLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var quoteCardView: UIView!

}


