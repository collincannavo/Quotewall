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
    
    public var currentFavoriteQuote: FavoriteQuote?
    
    
    // MARK: - Functions
    
    public func updateFavoriteQuote(_ favoriteQuote: FavoriteQuote, author: String, quote: String, backgroundImage: Data? = nil, completion: @escaping (Bool) -> Void) {
        
        favoriteQuote.name = author
        favoriteQuote.quote = quote
        favoriteQuote.backgroundImage = backgroundImage
        
        update(favoriteQuote) { (success) in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    
    public func createFavoriteQuote(with name: String, quote: String, image: Data? = nil, completion: @escaping (Bool) -> Void) {
        
        guard let person = PersonController.shared.currentPerson
            else { completion(false); return }
        
        // compress image here
        
        let quote = FavoriteQuote(name: name, quote: quote, backgroundImage: image)
        
        quote.reference = PersonController.shared.currentPerson?.ckReference
        
        PersonController.shared.addFavoriteQuotes(quote, to: person)
        
        completion(true)
        
        }
        
    public func update(_ favoriteQuote: FavoriteQuote, completion: @escaping (Bool) -> Void) {
        
        
        CloudKitController.shared.updateRecord(favoriteQuote.ckRecord, with: { (records, recordIDs, error) in
            if let error = error {
                NSLog("There was an error fetching the Favorite Quote to modify: \(error.localizedDescription)")
                completion(false)
                return }
            
            guard (records?.first != nil) else { NSLog("Did not successfully return the modified Favorite Quote"); completion(false); return }
            
            completion(true)
            })
        }
        
    }


    
    


