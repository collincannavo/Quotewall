//
//  SharedQuotesViewController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit
import ContactsUI

class MySharedQuotesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CNContactPickerDelegate {
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var sharedCollectionView: UICollectionView!
    
    let gradient = CAGradientLayer()
    var sharedQuotes: [SharedQuote]? {
        didSet {
            self.sharedCollectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sharedCollectionView.delegate = self
        sharedCollectionView.dataSource = self
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        longPress.minimumPressDuration = 0.5
        longPress.delegate = self as? UIGestureRecognizerDelegate
        longPress.delaysTouchesBegan = true
        self.sharedCollectionView?.addGestureRecognizer(longPress)
        
        fetchSharedQuotes()
        gradient.colors = [UIColor.gradientBlueColor.cgColor, UIColor.gradientGreenColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.frame = view.frame
        self.view.layer.insertSublayer(gradient, at: 0)
        
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        tabBarController?.tabBar.backgroundColor = UIColor.clear
        tabBarController?.tabBar.backgroundImage = UIImage()
        tabBarController?.tabBar.shadowImage = UIImage()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let sharedQuotes = self.sharedQuotes?[indexPath.row] else { return QuotesCollectionViewCell() }
        
        guard let cell = self.sharedCollectionView.dequeueReusableCell(withReuseIdentifier: "sharedQuoteCell", for: indexPath) as? QuotesCollectionViewCell else { return QuotesCollectionViewCell() }
        
        cell.authorNameLabel.text = sharedQuotes.name
        cell.quoteTextLabel.text = sharedQuotes.quote
        cell.titleLabel.text = sharedQuotes.title
        
        cellShadowing(cell)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let sharedQuotes = sharedQuotes?.count else { return 0 }
        
        return sharedQuotes
    }
    
    // MARK: - Alert
    
    func quoteActions(cell: SharedQuote, author: String, quote: String) {
        
        let alert = UIAlertController(title: "Shared Quote Options", message: "Don't want to share this quote anymore?", preferredStyle: .actionSheet)
        
        let removeSharedButton = UIAlertAction(title: "Remove Shared", style: .default) { (sharedButton) in
            
            guard let recordID = cell.ckRecordID else { return }
            
            CloudKitController.shared.deleteRecord(recordID, with: { 
                self.deleteSuccessful()
                
                DispatchQueue.main.async {
                    
                    self.sharedCollectionView.reloadData()
                }
            })
            
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        cancelButton.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(removeSharedButton)
        alert.addAction(cancelButton)
        
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
        
        let p = gesture.location(in: self.sharedCollectionView)
        
        if let indexPath = self.sharedCollectionView.indexPathForItem(at: p) {
            
            guard let cell = self.sharedQuotes?[indexPath.row] else { return }
            
            let author = cell.name
            let quote = cell.quote

            
            quoteActions(cell: cell, author: author, quote: quote)
        } else {
            NSLog("Couldn't find the right index path")
        }
        
    }

    // MARK: - Delete Successful Alert
    
    func deleteSuccessful() {
        let alert = UIAlertController(title: "Successfully Removed!", message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }

    
    // MARK: - Fetch My Shared Quotes
    
    func fetchSharedQuotes() {
        
        guard let currentPerson = PersonController.shared.currentPerson else { return }
        
        CloudKitController.shared.fetchSharedQuotes(for: currentPerson) { (success, sharedQuotes) in
            if success {
                DispatchQueue.main.async {
                    self.sharedQuotes = sharedQuotes
                }
            }
        }
    }
}
