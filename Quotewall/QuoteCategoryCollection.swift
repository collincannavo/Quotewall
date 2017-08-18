//
//  QuoteCategoryCollection.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit

class QuoteCategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CategoryPhotoSelectorCellDelegate {
    
    
    var quotewallCollectionView: QuotewallCollectionViewCell?
    
    // MARK: - Outlets
    
    @IBOutlet weak var quoteCategoryCollection: UICollectionView!
    
    // MARK: - Actions
    
    @IBAction func addQuotewallButtonTapped(_ sender: Any) {
        createQuotewallTitle()
    }
    var quoteWall: [Quotewall] = []
    
    // MARK: - CollectionView Lifecycle Functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return quoteWall.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let quotewall = PersonController.shared.currentPerson?.savedQuotewalls[indexPath.row]
        let newQuotewall = quotewall
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "quotewallCollectionCell", for: indexPath) as? QuotewallCollectionViewCell else { return QuotewallCollectionViewCell() }
        
        cell.categoryTitleLabel.text = newQuotewall?.category
        
        cell.quotewall = quotewall
        
        if let data = quotewall?.backgroundImage,
            let image = UIImage(data: data) {
            cell.categoryBackgroundImage.image = image
        }
        
        return cell
    }
    
    // MARK: - Create Quotewall title
    
    func createQuotewallTitle() {
        
        var quotewallTitle: UITextField?
        
        let alertController = UIAlertController(title: "Let's Do This!", message: "What would you like for your Quotewall title (e.g. Funny, Work, Family)?", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            quotewallTitle = textField
            quotewallTitle?.placeholder = "Title of Quotewall"
            
        }
        
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let title = quotewallTitle?.text else { return }
            
            if title.isEmpty {
                let alert = UIAlertController(title: "Please Add a title", message: nil, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(okButton)
              
                self.present(alert, animated: true, completion: nil)
                
            } else {
            
                QuotewallController.shared.createQuotewall(with: [], category: title)
                
                self.quoteCategoryCollection.reloadData()
        }
    }
        alertController.addAction(dismissAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - Background Image picker Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editQuoteCollection" {
            if let indexPath = self.quoteCategoryCollection.indexPathsForSelectedItems {
                let destinationVC = segue.destination as? QuoteCollectionViewController
                
                guard let quotes = QuotewallController.shared.currentQuotewall?.quotes else { return }
                destinationVC?.quotes = quotes
            }
        }
    }
    
}

