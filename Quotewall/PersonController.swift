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
    
    
    public func addPersonalQuote(_ quote: Quote, to person: Person) {
        person.personalQuotes.append(quote)
    }
    
    public func addQuote(_ quote: Quote, to person: Person) {
        person.quotes.append(quote)
    }
    
    public func addFavoriteQuotes(_ quote: FavoriteQuote, to person: Person) {
        person.favoriteQuotes.append(quote)
        
        CloudKitController.shared.save(record: quote.ckRecord) { (ckRecord, error) in
            if let error = error {
                NSLog("There was an error saving a favorite quote: \(error.localizedDescription)")
            }
        }
    }
    
    public func addSharedQuotes(_ quote: SharedQuote, to person: Person) {
        person.sharedQuotes.append(quote)
        
        CloudKitController.shared.save(record: quote.ckRecord) { (ckRecord, error) in
            if let error = error {
                NSLog("there was an error saving a shared quote: \(error.localizedDescription)")
            }
        }
    }
    
   
    public func removeFavoriteQuote(quote: FavoriteQuote, from person: Person, completion: @escaping () -> Void) {
        if let indexPath = person.favoriteQuotes.index(where: { $0 == quote}) {
        person.favoriteQuotes.remove(at: indexPath)
        
        
        guard let favoriteCKRecordID = quote.ckRecordID else { return }
        
            CloudKitController.shared.deleteRecord(favoriteCKRecordID) {
          completion()
            }
        }
    }

    public func deleteQuote(_ quote: Quote, from person: Person, with completion: @escaping (Bool) -> Void) {
        if let index = person.quotes.index(where: {$0 == quote}) {
            person.quotes.remove(at: index)
            
            self.update(for: person, completion: { (success) in
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
    public func update(for person: Person, completion: @escaping(Bool)-> Void) {
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












