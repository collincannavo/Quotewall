//
//  FavoriteQuoteController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/24/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import CloudKit
import UIKit


class FavoriteQuoteController {
    
    public static let shared = FavoriteQuoteController()
    
    
    
    // MARK: - Functions
    
    public func createFavoriteQuote(with name: String, quote: String, image: Data? = nil, completion: @escaping (Bool) -> Void) {
        
        guard let person = PersonController.shared.currentPerson else { completion(false); return }
        
        let quote = FavoriteQuote(name: name, quote: quote, backgroundImage: image)
        
        PersonController.shared.addFavoriteQuotes(quote, to: person)
            
        quote.reference = PersonController.shared.currentPerson?.ckReference
        
        }
        
        
        
        
        
        
    }
    
    


