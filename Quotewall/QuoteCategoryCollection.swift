//
//  QuoteCategoryCollection.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit

class QuoteCategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Outlets
    
    @IBOutlet weak var quoteCategoryCollection: UICollectionView!
    
    
    
    
    // MARK: - Actions
    
    @IBAction func addQuotewallButtonTapped(_ sender: Any) {
        createQuotewallTitle()
    }
    
    // MARK: - CollectionView Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchQuotewalls { (_) in
        self.quoteCategoryCollection.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: quotewallsWereSetNotification, object: nil)
    }
    
    func refresh() {
        self.quoteCategoryCollection.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return QuotewallController.shared.quotewalls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let quotewall = QuotewallController.shared.quotewalls[indexPath.row]
        
        let newQuotewall = quotewall
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "quoteCategoryCollectionCell", for: indexPath) as? CategoryCollectionViewCell else { return CategoryCollectionViewCell() }
        
        cell.quotewallTitle.text = newQuotewall.category
        
        cellShadowing(cell)
        
        cell.quotewall = quotewall
        
        return cell
    }
    
    // MARK: - Create Quotewall title
    
    func createQuotewallTitle() {
        
        var quotewallTitle: UITextField?
        
        let alertController = UIAlertController(title: "Let's Do This!", message: "What would you like for your Quotewall title (e.g. Funny, Work, Family)?", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            quotewallTitle = textField
            quotewallTitle?.placeholder = "Title of Quotewall"
            guard let title = quotewallTitle?.text else { return }
//            self.quotewall?.category = title
            
        }
        
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let title = quotewallTitle?.text else { return }
            
            if title.isEmpty {
                let alert = UIAlertController(title: "Sorry, I couldn't save it. Please add a title", message: nil, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(okButton)
              
                self.present(alert, animated: true, completion: nil)
                
            } else {
            
                QuotewallController.shared.createQuotewall(with: title)
                DispatchQueue.main.async {
                    self.quoteCategoryCollection.reloadData()
                }
        }
    }
        alertController.addAction(dismissAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - Background Image picker Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editQuoteCollection" {
            
            if let indexPath = self.quoteCategoryCollection.indexPathsForSelectedItems?.first,
                let detailsVC = segue.destination as? QuoteCollectionViewController {
                
                let quotewall = QuotewallController.shared.quotewalls[indexPath.row]
                
                        detailsVC.quotewall = quotewall
            }
        }
    }
    
    // MARK: - Cell Setup
    
    fileprivate func cellShadowing(_ cell: CategoryCollectionViewCell) {
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowRadius = 4
        cell.layer.shadowOffset = CGSize(width: 0, height: 4)
        cell.layer.shadowColor = UIColor.black.cgColor
        
    }
    
    
    // MARK: - Fetch quotewalls function
    func fetchQuotewalls(completion: @escaping(Bool) -> Void) {
        
        
        CloudKitController.shared.fetchCurrentUser { (success, person) in
            if success && (person != nil) {
                
                //  All quotewalls
                
                CloudKitController.shared.fetchCurrentPersonQuotewalls(completion: { (success, quotewalls) in
                   
                    if success {
                        
                        let dispatchGroup = DispatchGroup()
                        
                        for quotewall in QuotewallController.shared.quotewalls {
                            dispatchGroup.enter()
                            
                            CloudKitController.shared.fetchQuotesForQuotewall(quotewall, completion: { (success, quotes) in
                                quotewall.quotes = quotes
                                dispatchGroup.leave()
                            })
                        }
                        
                        dispatchGroup.notify(queue: DispatchQueue.main, execute: { 
                            completion(true)
                        })
                        
                    }
                    
                    // Use dispatch group to loop through and get all the quotes for the quotewall
                    
                    //  All quotes for all quotewalls
                    
                })
                
            }
        }
    }
}
