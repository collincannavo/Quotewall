//
//  QuoteController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import CloudKit

public class QuoteController {
    
    public static let shared = QuoteController()
    
    // MARK: - CRUD Functions
    
    public func createQuote(with name: String, text: String, image: Data?, vote: Double?, completion: @escaping (Bool) -> Void) {
        
        guard let quotewall = QuotewallController.shared.currentQuotewall else { completion(false); return }
        
        let quote = Quote(name: name, vote: vote, text: text, image: image)
        
        QuotewallController.shared.addPersonalQuote(quote, to: quotewall)
        
        quote.parentCKReference = QuotewallController.shared.currentQuotewall?.ckReference
        
        CloudKitController.shared.save(record: quote.ckRecord) { (record, error) in
            if let error = error {
                NSLog("Error encountered whiel saving personal quotes to CK: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    
    
}
