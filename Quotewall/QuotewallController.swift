//
//  QuotewallController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import CloudKit

public class QuotewallController {
    
    public static let shared = QuotewallController()
    
    public var currentQuotewall: Quotewall?
    
    public func addPersonalQuote(_ quote: Quote, to quotewall: Quotewall) {
        quotewall.personalQuotes.append(quote)
    }
    
    public func addQuote(_ quote: Quote, to quotewall: Quotewall) {
        quotewall.quotes.append(quote)
    }
    
    public func addQuoteReference(_ reference: CKReference, to quotewall: Quotewall) {
        quotewall.receivedQuotes.append(reference)
    }
    
    public func removePersonalQuoteReference(_ reference: CKReference, from quotewall: Quotewall) {
        if let index = quotewall.receivedQuotes.index(where: { ($0 == reference) }) {
            quotewall.receivedQuotes.remove(at: index)
        }
    }
    
    
    
}
