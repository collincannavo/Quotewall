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
    
    var quotes: [NetworkQuotes] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = collectionView.frame.width - 20
        
        let collectionViewHeight = collectionView.frame.height / 3
        
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onlineQuotesCell", for: indexPath) as? NetworkQuotesViewCell else { return NetworkQuotesViewCell() }
        
        let quote = quotes[indexPath.row]
        
        cell.quotes = quote
        
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
    
}
