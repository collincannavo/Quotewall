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
    
    public var currentQuotewall: Quotewall? {
        didSet {
            print("Current quotewall was set \(currentQuotewall?.category)")
        }
    }
    
    public var quotewalls: [Quotewall] = [] {
        didSet{
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: quotewallsWereSetNotification, object: self)
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
    
    public func addQuoteReference(_ reference: CKReference, to quotewall: Quotewall) {
        quotewall.receivedQuotes.append(reference)
    }
    
    public func removePersonalQuoteReference(_ reference: CKReference, from quotewall: Quotewall) {
        if let index = quotewall.receivedQuotes.index(where: { ($0 == reference) }) {
            quotewall.receivedQuotes.remove(at: index)
        }
    }
    
    public func createQuotewall(with category: String) {
        
        guard let userCKReference = PersonController.shared.currentPerson?.ckReference,
            let person = PersonController.shared.currentPerson
            else { return }
        
        let newQuotewall = Quotewall.init(userCKReference: userCKReference, category: category)
        
        newQuotewall.parentCKReference = PersonController.shared.currentPerson?.ckReference
        
        PersonController.shared.addQuotewall(newQuotewall, to: person)
        
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











