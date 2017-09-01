//
//  SearchQuotesViewController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

/*https://market.mashape.com/andruxnet/random-famous-quotes#get-endpoint
 
 */



import Foundation
import UIKit

class SearchQuotesViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var networkSearchBar: UISearchBar!
    
    var quotes: [NetworkQuotes] = []
    let gradient = CAGradientLayer()
    var quotewall: Quotewall?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        longPress.minimumPressDuration = 0.5
        longPress.delegate = self as? UIGestureRecognizerDelegate
        longPress.delaysTouchesBegan = true
        self.collectionView?.addGestureRecognizer(longPress)
        
        gradient.colors = [UIColor.gradientBlueColor.cgColor, UIColor.gradientGreenColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.frame = view.frame
        self.view.layer.insertSublayer(gradient, at: 0)
        
        networkSearchBar.backgroundColor = UIColor.clear
        networkSearchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        networkSearchBar.isTranslucent = true
        networkSearchBar.delegate = self
 
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quotes.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onlineQuotesCell", for: indexPath) as? NetworkQuotesViewCell else { return NetworkQuotesViewCell() }
        
        let quote = quotes[indexPath.row]
        
        cell.quotes = quote
        cellShadowing(cell)
        
        return cell
        
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
       
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        guard let searchText = searchBar.text else { print("Sorry I couldn't find that result");return }
        

                NetworkQuotesController.fetchQuote(with: searchText) { (quote) in
                    
                    
                    DispatchQueue.main.async {
                        
                        guard let quote = quote else { return }
                        self.quotes = quote
                        self.collectionView.reloadData()
                    
                    
            }
        }
        
        searchBar.text = ""
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // MARK: - Cell Setup
    
    fileprivate func cellShadowing(_ cell: NetworkQuotesViewCell) {
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowRadius = 4
        cell.layer.shadowOffset = CGSize(width: 0, height: 4)
        cell.layer.shadowColor = UIColor.black.cgColor
    }
    
    func quoteActions(cell: NetworkQuotes, author: String, quote: String) {
        let alert = UIAlertController(title: "Options", message: "You read something cool? Why not share it?", preferredStyle: .actionSheet)
        
        let shareQuoteButton = UIAlertAction(title: "Share Quote", style: .default) { (share) in
            
            self.createSharedQuote(author: author, quote: quote, image: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancel.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(shareQuoteButton)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state != .ended {
            return
        }
        
        let p = gesture.location(in: self.collectionView)
        
        if let indexPath = self.collectionView.indexPathForItem(at: p) {
            
            let cell = self.quotes[indexPath.row]
            
            let author = cell.author
            let quote = cell.quote
            
            
            quoteActions(cell: cell, author: author, quote: quote)
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

    // MARK: - Successfully Added Alert
    
    func successfullyAdded() {
        let alert = UIAlertController(title: "Successfully Shared!", message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK!", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    
}
