//
//  SharedQuoteController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/29/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import CloudKit


public class SharedQuoteController {
    
    public static let shared = SharedQuoteController()
    
    public func createSharedQuote(with name: String, quote: String, image backgroundImage: Data? = nil, completion: @escaping (Bool) -> Void) {
        
        guard let currentUser = PersonController.shared.currentPerson else
        { completion(false); return }
        
        let sharedQuote = SharedQuote(name: name, quote: quote, backgroundImage: backgroundImage)
        
        sharedQuote.reference = PersonController.shared.currentPerson?.ckReference
        
        PersonController.shared.addSharedQuotes(sharedQuote, to: currentUser) { 
            
            completion(true)
        }
        
            completion(true)
        
    }
    
}
