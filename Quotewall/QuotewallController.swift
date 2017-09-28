//
//  QuotewallController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import CloudKit


let quotewallsWereSetNotification = Notification.Name(rawValue: "quotewallsWereSet")

public class QuotewallController {
    
    public static let shared = QuotewallController()
    
    public var currentQuotewall: Quotewall?
    
    public var quotewalls: [Quotewall] = [] {
        didSet{
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: quotewallsWereSetNotification, object: self)
            }
        }
    }
    
    public func addQuotewall(_ quotewall: Quotewall) {
        
        quotewall.savedQuotewalls.append(quotewall)
        
        let record = quotewall.CKrecord
        
        CloudKitController.shared.save(record: record) { (record, error) in
            if let error = error {
                NSLog("There was an error saving quotewall: \(error.localizedDescription)")
                return
            }
        }
    }
    
    public func addPersonalQuote(_ quote: Quote, to quotewall: Quotewall) {
        
        quotewall.quotes.append(quote)
        
        let record = quote.ckRecord
        
        CloudKitController.shared.save(record: record) { (record, error) in
            if let error = error {
                NSLog("There was an error saving the quote: \(error.localizedDescription)")
                return
            }
        }
    }
    
    public func addQuote(_ quote: Quote, to quotewall: Quotewall) {
        quotewall.quotes.append(quote)
    }

    public func addQuotewall(to quotewall: Quotewall, to person: Person) {
        QuotewallController.shared.quotewalls.append(quotewall)
        
        let record = quotewall.CKrecord
        
        CloudKitController.shared.save(record: record) { (record, error) in
            if let error = error {
                NSLog("There was an error saving the quotewall: \(error.localizedDescription)")
                return
            }
        }
    }
    
    public func createQuotewall(with category: String, backgroundImage: Data? = nil) {
        
        guard let userCKReference = PersonController.shared.currentPerson?.ckReference,
            let person = PersonController.shared.currentPerson
            else { return }
        
        let newQuotewall = Quotewall(userCKReference: userCKReference, category: category, backgroundImage: backgroundImage)
        
        newQuotewall.userReference = PersonController.shared.currentPerson?.ckReference
        
        QuotewallController.shared.addQuotewall(to: newQuotewall, to: person)
        
    }
    
    public func createCKAsset(for data: Data?) -> CKAsset? {
        guard let data = data else { return nil }
        
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        
        try? data.write(to: fileURL, options: [.atomic])
        
        return CKAsset(fileURL: fileURL)
    }
    
    
    public func updatedQuote(with quote: Quote, name: String, text: String, backgroundImage: Data? = nil, completion: @escaping (Bool) -> Void ) {
        
        quote.name = name
        quote.text = text
        quote.image = backgroundImage
        
        updateToNewQuote(quote) { (success) in
            if success {
                completion(true)
            } else {
                completion(false)
            }   
        }
    }
    
    public func updateToNewQuote(_ quote: Quote, completion: @escaping (Bool)-> Void) {
        
        CloudKitController.shared.updateRecord(quote.ckRecord, with: { (records, recordIDs, error) in
            if let error = error {
                NSLog("There was an error fetching the Favorite Quote to modify: \(error.localizedDescription)")
                completion(false)
                return }
            
            guard (records?.first != nil) else { NSLog("Did not successfully return the modified Favorite Quote"); completion(false); return }
            
            completion(true)
        })
    }

}











