//
//  QuoteCollectionViewController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit



class QuoteCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var quotewall: Quotewall?
    
    var selectedQuote = UITapGestureRecognizer(target: self, action: #selector(quoteActions))
    
    func quoteActions() {
        let alert = UIAlertController(title: "Options", message: "", preferredStyle: .actionSheet)
        
        let deleteButton = UIAlertAction(title: "Delete Quote", style: .default) { (delete) in
            
            guard let recordID = QuoteController.shared.quotes.first?.ckRecordID else { return }
            
            CloudKitController.shared.deleteRecord(recordID, with: { 
                self.deleteSuccessful()
            })
        }
        
        let addImageButton = UIAlertAction(title: "Add Background Image", style: .default) { (image) in
            
        }
        
        alert.addAction(deleteButton)
        alert.addAction(addImageButton)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Constants.currentUserQuotewallsNotification, object: nil)
        collectionView.delegate = self
        collectionView.dataSource = self
        cloudKitFetchQuotes()
//        updateViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    
    func refresh(){
        self.collectionView.reloadData()
    }
    
    // MARK: - CollectionView Lifecycle Functions
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let quotes = quotewall?.quotes[indexPath.row] else { return UICollectionViewCell() }
        
        let newquotes = quotes
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "quoteCollectionCell", for: indexPath) as? QuotesCollectionViewCell else { return QuotesCollectionViewCell() }
        
        cell.authorNameLabel?.text = newquotes.name
        cell.quoteTextLabel?.text = newquotes.text
        
        if let data = newquotes.image,
            let image = UIImage(data: data) {
            cell.backgroundImage.image = image
            cell.backgroundImage.contentMode = .scaleAspectFit
        }
        
        cellShadowing(cell)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let quotewall = quotewall else { return 0 }
        
        return quotewall.quotes.count
    }

    // MARK: - Prepare for Segue
    
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
    
    func deleteSuccessful() {
        let alert = UIAlertController(title: "Successfully Deleted", message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Cell Setup
    
    fileprivate func cellShadowing(_ cell: QuotesCollectionViewCell) {
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowRadius = 4
        cell.layer.shadowOffset = CGSize(width: 0, height: 4)
        cell.layer.shadowColor = UIColor.black.cgColor
    }
    
//    func updateViews(){
//        quotewall?.category = navigationItem.title!
//    }
    
}
