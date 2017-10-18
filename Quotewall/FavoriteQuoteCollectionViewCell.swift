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
    
    weak var delegate: RemoveButtonTappedDelegate?
    
    var favoriteQuote: FavoriteQuote?
    
    @IBOutlet weak var favoriteQuoteView: UIView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBAction func removeButtonTapped(_ sender: Any) {
        
        guard let person = PersonController.shared.currentPerson,
            let favoriteQuote = self.favoriteQuote
            else { return }
        
        PersonController.shared.removeFavoriteQuote(quote: favoriteQuote, from: person) { 
            
            DispatchQueue.main.async {
                
                self.delegate?.reloadTableViewFromDeletion(cell: self)
            }
        }
    }
}

protocol RemoveButtonTappedDelegate: class {
    func reloadTableViewFromDeletion(cell: FavoriteQuoteCollectionViewCell)
}
