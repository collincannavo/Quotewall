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
    
    @IBAction func testButton(_ sender: Any) {
        
        print("test worked")
        guard let quote = quoteLabel.text,
            let author = authorLabel.text
            else { return }
        
        FavoriteQuoteController.shared.createFavoriteQuote(with: author, quote: quote, image: nil) { (success) in
            if !success {
                NSLog("There was an error creating a favorite quote")
            }
        }
        
    }
    
    var quotes: NetworkQuotes? {
        didSet {
            updateViews()
        }
    }

    
    func updateViews() {

        guard let quote = quotes else { return }
        
        self.quoteLabel.text = quote.quote
        self.authorLabel.text = quote.author
        
    }
    
    
    
}
