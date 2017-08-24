//
//  FavoritesViewController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var person: Person?
    
    override func viewDidLoad() {
        updateView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = collectionView.frame.width - 20
        
        let collectionViewHeight = collectionView.frame.height / 3
        
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return person?.favoriteQuotes.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let favoriteQuote = person?.favoriteQuotes[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteQuoteCell", for: indexPath) as? FavoriteQuoteCollectionViewCell else { return FavoriteQuoteCollectionViewCell() }
        
        cell.authorLabel.text = favoriteQuote?.name
        cell.quoteLabel.text = favoriteQuote?.quote
        
        return cell
        
    }
    
    func updateView() {
        
        CloudKitController.shared.fetchCurrentUser { (success, person) in
            if success && person != nil {
                
                guard let currentPerson = person else { return }
                
                CloudKitController.shared.fetchFavoriteQuotes(for: currentPerson, completion: { (_) in
                    if success {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                })
            }
        }
        
    }
    
}
