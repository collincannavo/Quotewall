//
//  NetworkQuotesViewCell.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/16/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit

class NetworkQuotesViewCell: UICollectionViewCell {
    
    @IBOutlet weak var quoteView: UIView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var quotes: NetworkQuotes? {
        didSet {
            updateViews()
        }
    }
    
//    @IBAction func addToFavoritesButtonTapped(_ sender: Any) {
//        
//        guard let quote = quote else { return }
//        
//        let person = PersonController.shared.currentPerson
//        
//        PersonController.shared.addFavoriteQuotes(quote, to: person)
//    }
    
    func updateViews() {

        guard let quote = quotes else { return }
        
        self.quoteLabel.text = quote.quote
        self.authorLabel.text = quote.author
        self.categoryLabel.text = quote.category
    }
    
    
    
}
