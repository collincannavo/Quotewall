//
//  PersonController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/16/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit
import CloudKit


public class PersonController {
    
    public static let shared = PersonController()
    
    public var currentPerson: Person?
    
    public func addQuotewall(_ quotewall: Quotewall, to person: Person) {
        person.savedQuotewalls.append(quotewall)
        
        let record = quotewall.CKrecord
        
        CloudKitController.shared.save(record: record) { (record, error) in
            if let error = error {
                NSLog("There was an error saving quotewall: \(error.localizedDescription)")
            }
        }
    }
    
    public func addPersonalQuote(_ quote: Quote, to person: Person) {
        person.personalQuotes.append(quote)
    }
    
    public func addQuote(_ quote: Quote, to person: Person) {
        person.quotes.append(quote)
    }
    
    public func addFavoriteQuotes(_ quote: Quote, to person: Person) {
        person.favoriteQuotes.append(quote)
    }
    
    public func removeQuoteReference(ckReference: CKReference, from person: Person) {
        if let index = person.receivedQuotes.index(where: {$0 == ckReference}) {
            person.receivedQuotes.remove(at: index)
        }
    }
    
    public func removeAllQuotewalls(from person: Person) {
        person.savedQuotewalls.removeAll()
    }
    
    public func removeFavoriteQuote(from person: Person, at indexPath: IndexPath) {
        person.favoriteQuotes.remove(at: indexPath.row)
    }
    
    public func deleteQuote(_ quote: Quote, from person: Person, with completion: @escaping (Bool) -> Void) {
        if let index = person.quotes.index(where: {$0 == quote}) {
            person.quotes.remove(at: index)
            
            if let reference = quote.ckReference {
                removeQuoteReference(ckReference: reference, from: person)
            }
            
            self.updateQuote(for: person, completion: { (success) in
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            })
        }
    }
    
    public func removeAllQuotes(from person: Person) {
        person.quotes.removeAll()
    }
    public func updateQuote(for person: Person, completion: @escaping(Bool)-> Void) {
        guard let recordID = person.ckRecordID else { return }
        CloudKitController.shared.fetchRecord(with: recordID) { (record, error) in
            if let error = error { NSLog("There was an error fetching the record for the update: \(error.localizedDescription)"); completion(false); return }
            
            guard var record = record else { NSLog("Record returned for update operation is nil"); completion(false); return }
            
            person.updateCKRecordLocally(record: &record)
            
            CloudKitController.shared.updateRecord(record, with: { (records, recordIDs, error) in
                if let error = error { NSLog("There was an error updating records: \(error.localizedDescription)"); completion(false); return }
                
                guard records?.first != nil else { NSLog("Did not successfully update the record"); completion(false); return }
                
            })
        }
    }
}












