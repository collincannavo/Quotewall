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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
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
    
}
