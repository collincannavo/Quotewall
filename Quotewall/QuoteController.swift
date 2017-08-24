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

let quotesWereSetNotification = Notification.Name(rawValue: "quotesWereSet")

public class QuoteController {
    
    public static let shared = QuoteController()
    
    // MARK: - Properties
    
    var quotes: [Quote] = []
    
    // MARK: - CRUD Functions
    
    public func createQuote(with name: String, text: String, image: Data?, completion: @escaping (Bool) -> Void) {
        
        guard let quotewall = QuotewallController.shared.currentQuotewall
            else { completion(false); return }
        
        let quote = Quote(name: name, text: text, image: image, quotewallReference: quotewall.ckReference)
        
        QuotewallController.shared.addPersonalQuote(quote, to: quotewall)
        
        quote.parentCKReference = QuotewallController.shared.currentQuotewall?.ckReference
    }

}
