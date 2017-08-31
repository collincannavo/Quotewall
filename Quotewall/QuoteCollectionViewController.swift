//
//  QuoteCollectionViewController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit



class QuoteCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let gradient = CAGradientLayer()
    var quotewall: Quotewall?
    var person: Person?
    

    
    func quoteActions(author: String, quote: String, image: Data?) {
        let alert = UIAlertController(title: "Options", message: "", preferredStyle: .actionSheet)
        
        let shareQuoteButton = UIAlertAction(title: "Share Quote", style: .default) { (share) in
            
            self.createSharedQuote(author: author, quote: quote, image: image)
        }
        
        let deleteButton = UIAlertAction(title: "Delete Quote", style: .default) { (delete) in
            
            guard let recordID = QuoteController.shared.quotes.first?.ckRecordID else { return }
            
            CloudKitController.shared.deleteRecord(recordID, with: { 
                self.deleteSuccessful()
            })
        }
        
        let removeFromSharedButton = UIAlertAction(title: "Remove Shared", style: .default) { (remove) in
            
            guard let sharedQuote = self.person?.sharedQuotes.first,
                let person = self.person
                else { return }
            
            PersonController.shared.removeSharedQuote(quote: sharedQuote, from: person, completion: {})
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancel.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(shareQuoteButton)
        alert.addAction(removeFromSharedButton)
        alert.addAction(deleteButton)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        longPress.minimumPressDuration = 0.5
        longPress.delegate = self as? UIGestureRecognizerDelegate
        longPress.delaysTouchesBegan = true
        self.collectionView?.addGestureRecognizer(longPress)

        collectionView.delegate = self
        collectionView.dataSource = self
        cloudKitFetchQuotes()
        
        navigationBar.topItem?.title = quotewall?.category
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        gradient.colors = [UIColor.gradientBlueColor.cgColor, UIColor.gradientGreenColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.frame = view.frame
        self.view.layer.insertSublayer(gradient, at: 0)
        
        QuotewallController.shared.currentQuotewall = self.quotewall
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
        cloudKitFetchQuotes()
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
            cell.backgroundImage.contentMode = .scaleToFill
        }
        
        cellShadowing(cell)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let quotewall = quotewall else { return 0 }
        
        return quotewall.quotes.count

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        let spacing: CGFloat = 20.0
        
        return spacing
        
        
    }

    // MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
        if segue.identifier == "addQuote" {
            
            let destinationVC = segue.destination as? QuotesTemplateViewController
            
            destinationVC?.senderIsMainCollection = false
            destinationVC?.quotewall = quotewall
            
        }
        
        if segue.identifier == "editQuote",
            let indexPath = self.collectionView.indexPathsForSelectedItems?.first {
            
            let destinationVC = segue.destination as? QuotesTemplateViewController
            
            let selectedQuote = QuotewallController.shared.currentQuotewall?.quotes[indexPath.row]
            
            destinationVC?.quote = selectedQuote
            destinationVC?.senderIsMainCollection = true
            
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
    
    func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state != .ended {
            return
        }
        
        let p = gesture.location(in: self.collectionView)
        
        if let indexPath = self.collectionView.indexPathForItem(at: p) {
            
            guard let cell = quotewall?.quotes[indexPath.row] else { return }
            
                let author = cell.name
                let quote = cell.text
                let image = cell.image
        
            quoteActions(author: author, quote: quote, image: image)
        } else {
            NSLog("Couldn't find the right index path")
        }
        
    }

    func createSharedQuote(author: String, quote: String, image: Data?) {

                let author = author
                let quote = quote
                let image = image
        
        SharedQuoteController.shared.createSharedQuote(with: author, quote: quote, image: image) { (success) in
            if success {
                self.successfullyAdded()
            }
        }
        
    }
    
    func successfullyAdded() {
        let alert = UIAlertController(title: "Successfully Shared!", message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK!", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
}










