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
    
    public func createQuote(with name: String, text: String, image: Data?, completion: @escaping (Bool) -> Void) {
//   
//        CloudKitController.shared.fetchCurrentQuotewall { (success, quotewall) in
//            if success {
//                completion(true)
//                return
//            } else {
//                NSLog("There was an error fetching the current quotewall")
//            }
//        }
        
        guard let quotewall = QuotewallController.shared.currentQuotewall,
            let userCKReference = QuotewallController.shared.currentQuotewall?.ckReference
        else { completion(false); return }
        
        let quote = Quote(name: name, text: text, image: image, userCKReference: userCKReference)
        
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
    
    public func fetchPersonalQuotes(with completion: @escaping (Bool)-> Void) {
        guard let currentPersonID = PersonController.shared.currentPerson?.ckRecordID else { completion(false); return }
        
        let currentPersonCKReference = CKReference(recordID: currentPersonID, action: .none)
        
        let predicate = NSPredicate(format: "\(Quote.parentKey) == %@ ", currentPersonCKReference)
        
        CloudKitController.shared.performQuery(with: predicate, completion: { (records, error) in
            if let error = error {
                NSLog("There was an error fetching quotes: \(error.localizedDescription)"); completion(false); return }
            
            guard let records = records else { NSLog("Returned profile quotes are nil"); completion(false); return }
            
            guard let currentPerson = PersonController.shared.currentPerson else { completion(false); return }
            
            let quotes = records.flatMap {Quote(ckRecord: $0)}
            quotes.forEach { PersonController.shared.addQuote($0, to: currentPerson) }
            completion(true)
        })
    }
    
//    public func fetchSharedQuotes(with completion: @escaping (Bool)-> Void){
//        guard let currentPerson = PersonController.shared.currentPerson else { completion(false); return }
//        
//        PersonController.shared.removeAllQuotes(from: currentPerson)
//        
//        let sharedQuotesCKRecordID = currentPerson.receivedQuotes.map {$0.recordID}
//        
//        CloudKitController.shared.fetchAllQuotes(for: sharedQuotesCKRecordID) { (recordsDictionary, error) in
//            
//            defer { completion(true) }
//            
//            if let error = error { NSLog("There was an error fetching all shared quotes: \(error.localizedDescription)"); completion(false); return }
//            
//            guard let cardRecordsDictionary = recordsDictionary else { NSLog("Records returned for shared cards is nil"); completion(false); return }
//            
//            let newQuotes = cardRecordsDictionary.flatMap({Quote(ckRecord: $0.value)})
//            newQuotes.forEach({PersonController.shared.addQuote($0, to: currentPerson)})
//            completion(true)
//            
//        }
//    }


}
