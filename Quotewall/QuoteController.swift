//
//  QuoteController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

public class QuoteController {
    
    public static let shared = QuoteController()
    
    // MARK: - CRUD Functions
    
    public func createQuote(with name: String, text: String, image: Data?, quotewall: Quotewall, completion: @escaping (Bool) -> Void) {
        
        let quote = Quote(name: name, text: text, image: image, quotewallReference: quotewall.ckReference)
        
        QuotewallController.shared.addPersonalQuote(quote, to: quotewall)
        
        quote.parentCKReference = QuotewallController.shared.currentQuotewall?.ckReference
        
        completion(true)
    }

    public func removeQuote(_ quote: Quote, from quotewall: Quotewall, completion: @escaping(Bool)->Void) {
        
        if let index = quotewall.quotes.index(where: {$0 == quote }) {
            quotewall.quotes.remove(at: index)
        }
        
        guard let ckRecordID = quote.ckRecordID else { completion(false); return }
        
        CloudKitController.shared.deleteRecord(ckRecordID) { 
                completion(true)
        }
    }
    
}
