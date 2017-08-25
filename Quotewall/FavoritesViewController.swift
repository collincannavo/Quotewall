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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        updateView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateView()
        
    }
    @IBAction func removeButtonTapped(_ sender: Any) {
        
        
        
//        PersonController.shared.removeFavoriteQuote(from: <#T##Person#>, at: <#T##IndexPath#>)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let person = PersonController.shared.currentPerson else { return 0 }
        
        return person.favoriteQuotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let favoriteQuote = PersonController.shared.currentPerson?.favoriteQuotes[indexPath.row]
        
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
                            self.collectionView.reloadData()
                        }
                        
                    }
                })
            }
            
            
        }
    }
    
//    func removeQuote(favoriteQuote: FavoriteQuote, at indexPath: IndexPath) {
//        
//        guard let currentPerson = PersonController.shared.currentPerson else { return }
//        
//        let indexPath = person?.favoriteQuotes[indexPath.row]
//        
//        PersonController.shared.removeFavoriteQuote(from: <#T##Person#>, at: <#T##IndexPath#>)
//        
//    }
    
    
    // MARK: - Cell Setup
    
    fileprivate func cellShadowing(_ cell: FavoriteQuoteCollectionViewCell) {
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowRadius = 4
        cell.layer.shadowOffset = CGSize(width: 0, height: 4)
        cell.layer.shadowColor = UIColor.black.cgColor
    }
    
}
