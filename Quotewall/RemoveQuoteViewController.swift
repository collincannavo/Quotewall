//
//  RemoveQuoteViewController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit

class RemoveQuoteViewController: UIViewController {
    
    
    // MARK: - Properties
    
    var quote: Quote?
    
    // MARK: - Action Buttons
    
    @IBAction func removeButtonTapped(_ sender: Any) {
        
        guard let person = PersonController.shared.currentPerson,
            let quote = quote
        else { return }
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.startAnimating()
        
        PersonController.shared.deleteQuote(quote, from: person) { (success) in
            
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.presentFailedDeleteAlert()
            }
            
        }
        activityIndicator.stopAnimating()
    
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    
    }
    
    // MARK: - Alert Action
    
    func presentFailedDeleteAlert() {
        let alert = UIAlertController(title: "Could Not Delete", message: "Unable to delete the current quote", preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okayButton)
        
        present(alert, animated: true, completion: nil)
    }
    
}
