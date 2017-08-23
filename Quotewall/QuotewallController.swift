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
    
    public func addSavedQuotewall(to quotewall: Quotewall) {
        quotewall.savedQuotewalls.append(quotewall)
        
        let record = quotewall.CKrecord
        
        CloudKitController.shared.save(record: record) { (record, error) in
            if let error = error {
                NSLog("There was an error saving the quotewall: \(error.localizedDescription)")
                return
            }
        }
    }
    
    public func addQuote(_ quote: Quote, to quotewall: Quotewall) {
        quotewall.quotes.append(quote)
    }

    public func addQuotewall(to quotewall: Quotewall, to person: Person) {
        quotewall.savedQuotewalls.append(quotewall)
        
        let record = quotewall.CKrecord
        
        CloudKitController.shared.save(record: record) { (record, error) in
            if let error = error {
                NSLog("There was an error saving the quotewall: \(error.localizedDescription)")
                return
            }
        }
    }
    
    public func createQuotewall(with category: String) {
        
        guard let userCKReference = PersonController.shared.currentPerson?.ckReference,
            let person = PersonController.shared.currentPerson
            else { return }
        
        let newQuotewall = Quotewall(userCKReference: userCKReference, category: category)
        
        newQuotewall.userReference = PersonController.shared.currentPerson?.ckReference
        
        QuotewallController.shared.addQuotewall(to: newQuotewall, to: person)
        
    }
    
    public func createCKAsset(for data: Data?) -> CKAsset? {
        guard let data = data,
            let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return nil }
        
        let directoryAsNSString = directory as NSString
        let path = directoryAsNSString.appendingPathComponent("asset.txt")
        
        FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
        let fileURL = URL(fileURLWithPath: path)
        
        return CKAsset(fileURL: fileURL)
    }
    
    
    
}











