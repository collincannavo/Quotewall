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
    public var quotewalls: [Quotewall] = []
    
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
    
    public func createQuotewall(with quotes: [Quote] = [], category: String) {
        
        guard let userCKReference = PersonController.shared.currentPerson?.ckReference,
            let person = PersonController.shared.currentPerson,
            let ckRecordID = PersonController.shared.currentPerson?.ckRecordID
            else { return }
        
        let newQuotewall = Quotewall.init(userCKReference: userCKReference, category: category, ckRecordID: ckRecordID)
        
        PersonController.shared.addQuotewall(newQuotewall, to: person)
        
    }
}
