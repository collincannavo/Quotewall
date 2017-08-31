//
//  CategoryCollectionViewCell.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/18/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var quotewallTitle: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var quotewall: Quotewall?{
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        
        guard let quotewall = quotewall,
            let backgroundImage = backgroundImage
        else { return }
        
        self.quotewallTitle.text = quotewall.category
//        self.backgroundImage.image = quotewall.backgroundImage
        
    }
    
    
}
