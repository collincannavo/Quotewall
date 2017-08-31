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
    
    let gradient = CAGradientLayer()
    var currentFavorite: FavoriteQuote?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        updateView()
        
        gradient.colors = [UIColor.gradientBlueColor.cgColor, UIColor.gradientGreenColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.frame = view.frame
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateView()
        
    }
    @IBAction func removeButtonTapped(_ sender: Any) {
        
        guard let person = PersonController.shared.currentPerson,
            let favoriteQuote = currentFavorite
        else { return }
        
        PersonController.shared.removeFavoriteQuote(quote: favoriteQuote, from: person) { }
        
        self.collectionView.reloadData()
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let person = PersonController.shared.currentPerson else { return 0 }
        
        return person.favoriteQuotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let favoriteQuote = PersonController.shared.currentPerson?.favoriteQuotes[indexPath.row]
        
        self.currentFavorite = favoriteQuote
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteQuoteCell", for: indexPath) as? FavoriteQuoteCollectionViewCell else { return FavoriteQuoteCollectionViewCell() }
        
        cell.authorLabel.text = favoriteQuote?.name
        cell.quoteLabel.text = favoriteQuote?.quote
        
        if let data = favoriteQuote?.backgroundImage,
            let image = UIImage(data: data) {
            cell.backgroundImage.image = image
            cell.backgroundImage.contentMode = .scaleToFill
        }

        
        cellShadowing(cell)
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toQuoteTemplate",
            let indexPath = self.collectionView.indexPathsForSelectedItems?.first {
            
            let destinationVC = segue.destination as? QuotesTemplateViewController
            

            let selectedQuote = PersonController.shared.currentPerson?.favoriteQuotes[indexPath.row]
            
            destinationVC?.favoriteQuote = selectedQuote
            destinationVC?.senderIsFavoriteCollection = true
            
        }
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
    
    
    // MARK: - Cell Setup
    
    fileprivate func cellShadowing(_ cell: FavoriteQuoteCollectionViewCell) {
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowRadius = 4
        cell.layer.shadowOffset = CGSize(width: 0, height: 4)
        cell.layer.shadowColor = UIColor.black.cgColor
    }
    
}
