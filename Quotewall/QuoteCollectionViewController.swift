//
//  QuoteCollectionViewController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit

class QuoteCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var quotes: [Quote] = []
    var quotewall: Quotewall?
    
    override func viewDidLoad() {
        self.navigationItem.title = quotewall?.category
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let quotes = QuotewallController.shared.currentQuotewall?.quotes[indexPath.row]
        
        let newquotes = quotes
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "quoteCollectionCell", for: indexPath) as? QuotesCollectionViewCell else { return QuotesCollectionViewCell() }
        
        cell.authorNameLabel?.text = newquotes?.name
        cell.quoteTextLabel?.text = newquotes?.text
        
        if let data = newquotes?.image,
            let image = UIImage(data: data) {
            cell.backgroundImage?.image = image
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return QuotewallController.shared.currentQuotewall?.quotes.count ?? 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
        if segue.identifier == "editQuote",
            let indexPath = self.collectionView.indexPathsForSelectedItems?.first {
            
            let destinationVC = segue.destination as? QuotesTemplateViewController
            
            let selectedQuote = QuotewallController.shared.currentQuotewall?.quotes[indexPath.row]
            
                destinationVC?.quote = selectedQuote
                
            }
        }
    }

