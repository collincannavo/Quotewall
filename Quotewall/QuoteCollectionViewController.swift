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
    
    var quoteCollection: [Quote] = []
    
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Constants.currentUserQuotewallsNotification, object: nil)
        collectionView.delegate = self
        collectionView.dataSource = self
        cloudKitFetchQuotes()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    
    func refresh(){
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let quotes = quoteCollection[indexPath.row]
        
        let newquotes = quotes
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "quoteCollectionCell", for: indexPath) as? QuotesCollectionViewCell else { return QuotesCollectionViewCell() }
        
        cell.authorNameLabel?.text = newquotes.name
        cell.quoteTextLabel?.text = newquotes.text
        
        if let data = newquotes.image,
            let image = UIImage(data: data) {
            cell.backgroundImage?.image = image
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return quoteCollection.count 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
        if segue.identifier == "editQuote",
            let indexPath = self.collectionView.indexPathsForSelectedItems?.first {
            
            let destinationVC = segue.destination as? QuotesTemplateViewController
            
            let selectedQuote = QuotewallController.shared.currentQuotewall?.quotes[indexPath.row]
            
                destinationVC?.quote = selectedQuote
                
            }
        }
    
    func cloudKitFetchQuotes() {
        
        CloudKitController.shared.fetchPersonalQuotes(completion: { (success, quotes) in
            if success {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        })
    }
}
