//
//  SearchQuotesViewController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit

class SearchQuotesViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var quotes: [NetworkQuotes] = [] {
        didSet {
        
            DispatchQueue.main.async {
               
            }
        }
    }
    
    
    override func viewDidLoad() {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cgSize = CGSize(width: 4, height: 4)
        
        return cgSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onlineQuotesCell", for: indexPath) as? NetworkQuotesViewCell else { return NetworkQuotesViewCell() }
        
        let quote = quotes[indexPath.row]
        
        cell.quotes = quote
        
        return UICollectionViewCell()
        
    }
    
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        guard let searchText = searchBar.text else { print("Sorry I couldn't find that result");return }
        
            
            DispatchQueue.main.async {

                NetworkQuotesController.fetchQuote(with: searchText) { (quote) in
                    guard let quote = quote else { return }
                    self.quotes = [quote]
                    
                
            }
        }
    }
    
    
}
