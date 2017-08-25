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
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        updateView()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = collectionView.frame.width - 20
        
        let collectionViewHeight = collectionView.frame.height / 3
        
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let person = person else { return 0 }
        
        return person.favoriteQuotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let favoriteQuote = person?.favoriteQuotes[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteQuoteCell", for: indexPath) as? FavoriteQuoteCollectionViewCell else { return FavoriteQuoteCollectionViewCell() }
        
        cell.authorLabel.text = favoriteQuote?.name
        cell.quoteLabel.text = favoriteQuote?.quote
        
        cellShadowing(cell)
        
        return cell
        
    }
    
    func updateView() {
        
        CloudKitController.shared.fetchCurrentUser { (success, person) in
            if success && (person != nil) {
                
                guard let user = PersonController.shared.currentPerson
                    else { return }
                
                CloudKitController.shared.fetchFavoriteQuotes(for: user, completion: { (success, favoriteQuotes) in
            
                    if success {
                        DispatchQueue.main.async {
                            self.person?.favoriteQuotes = favoriteQuotes
                            print("the number of favorite quotes after success is ", self.person?.favoriteQuotes.count)
                            self.collectionView.reloadData()
                        }
                        
                    }
                })
            }
            
            
        }
        
    }
    
    // MARK: - Cell Setup
    
    fileprivate func cellShadowing(_ cell: FavoriteQuoteCollectionViewCell) {
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowRadius = 4
        cell.layer.shadowOffset = CGSize(width: 0, height: 4)
        cell.layer.shadowColor = UIColor.black.cgColor
    }
    
}
