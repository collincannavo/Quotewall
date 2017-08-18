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
    
    var quotewall: Quotewall?{
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        
        guard let quotewall = quotewall else { return }
        
        self.quotewallTitle.text = quotewall.category
            
        
    }
    
    
}
