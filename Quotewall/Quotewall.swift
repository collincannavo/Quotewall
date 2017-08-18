//
//  Quotewall.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import CloudKit

public class Quotewall {
    
    public static let quotesKey = "quotes"
    public static let categoryKey = "category"
    public static let quoteCountKey = "count"
    public static let appleUserReferenceKey = "appleUserReference"
    public static let receivedQuotesKey = "receivedQuotes"
    public static let recordTypeKey = "Quotewall"
    public static let parentKey = "parent"
    
    public var ckRecordID: CKRecordID?
    public var userReference: CKReference?
    public var category: String
    public var backgroundImage: Data?
    public var receivedQuotes: [CKReference] = []
    public var personalQuotes: [Quote] = []
    public var quotes: [Quote] = []
    
    public let initialQuotesFetchComplete = false
    public let intialPersonalQuotesFetchComplete = false
    
    public var parentCKReference: CKReference?
    
    public var parentCKRecordID: CKRecordID? {
        return parentCKReference?.recordID
    }
    
    public var sortedPersonalQuote: [Quote] {
        return personalQuotes.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
    }
    
    public var sortedQuotes: [Quote] {
        return quotes.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
    }
    
    public var ckReference: CKReference? {
        guard let ckRecordID = ckRecordID else { return nil }
        return CKReference(recordID: ckRecordID, action: .none)
    }
    
    public var CKrecord: CKRecord {
     let recordID = self.ckRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        let record = CKRecord(recordType: Quotewall.recordTypeKey, recordID: recordID)
        
        record[Quotewall.quotesKey] = quotes as CKRecordValue?
        record[Quotewall.appleUserReferenceKey] = userReference as CKRecordValue?
        
        
        if !receivedQuotes.isEmpty {
            record[Quotewall.receivedQuotesKey] = receivedQuotes as CKRecordValue?
        }
        self.ckRecordID = recordID
        return record
    }
    
    public init(_ quotes: [Quote] = [], userCKReference: CKReference, category: String, backgroundImage: Data? = nil) {
        self.quotes = quotes
        self.userReference = userCKReference
        self.category = category
        self.backgroundImage = backgroundImage
    }
    
    public init?(CKRecord: CKRecord) {
        guard let quotes = CKRecord[Quotewall.quotesKey] as? [Quote],
            let category = CKRecord[Quotewall.categoryKey] as? String
        else { return nil }
        
        self.quotes = quotes
        self.category = category
        self.userReference = CKRecord[Quotewall.appleUserReferenceKey] as? CKReference
        
        let receivedQuotes = CKRecord[Quotewall.receivedQuotesKey] as? [CKReference] ?? []
        self.receivedQuotes = receivedQuotes
        
        self.ckRecordID = CKRecord.recordID
    }
    
    public func updateCKRecordLocally(record: inout CKRecord) {
        record[Quotewall.quotesKey] = quotes as CKRecordValue?
        record[Quotewall.appleUserReferenceKey] = userReference as CKRecordValue?
        
        if receivedQuotes.isEmpty {
            record[Quotewall.receivedQuotesKey] = nil
        } else {
            record[Quotewall.receivedQuotesKey] = receivedQuotes as CKRecordValue?
        }
    }
    
}

extension Quotewall: Equatable {
    public static func ==(lhs: Quotewall, rhs: Quotewall) -> Bool {
        return lhs.category == rhs.category && lhs.ckRecordID == rhs.ckRecordID
    }
}
