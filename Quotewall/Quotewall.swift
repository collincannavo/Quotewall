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
    
    
    public static let categoryKey = "category"
    public static let quoteCountKey = "count"
    public static let quotewallReferenceKey = "quotewallReference"
    public static let receivedQuotesKey = "receivedQuotes"
    public static let recordTypeKey = "Quotewall"
    public static let parentKey = "parent"
    public static let backgroundImage = "backgroundImage"
    
    public var ckRecordID: CKRecordID?
    public var userReference: CKReference?
    public var category: String
    public var backgroundImage: Data?
    public var receivedQuotes: [CKReference] = []
 
    public var quotes: [Quote] = []
    
    public let initialQuotesFetchComplete = false
    public let intialPersonalQuotesFetchComplete = false
    
    public var parentCKReference: CKReference?
    
    public var parentCKRecordID: CKRecordID? {
        return parentCKReference?.recordID
    }
    

    
    public var sortedQuotes: [Quote] {
        return quotes.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
    }
    
    public var ckReference: CKReference? {
        guard let ckRecordID = self.ckRecordID else { return nil }
        return CKReference(recordID: ckRecordID, action: .none)
    }
    
    public var CKrecord: CKRecord {
        let recordID = self.ckRecordID ?? CKRecordID(recordName: UUID().uuidString)
        let record = CKRecord(recordType: Quotewall.recordTypeKey, recordID: recordID)
        
        record[Quotewall.quotewallReferenceKey] = userReference as CKRecordValue?
        record[Quotewall.categoryKey] = category as CKRecordValue?
        
        let backgroundImageAsset = QuotewallController.shared.createCKAsset(for: self.backgroundImage)
        
        record[Quotewall.backgroundImage] = backgroundImageAsset as CKAsset?

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
        
        guard let category = CKRecord[Quotewall.categoryKey] as? String,
            let userReference = CKRecord[Quotewall.quotewallReferenceKey] as? CKReference
        else { return nil }
        
        self.category = category
        self.userReference = userReference
        
        self.ckRecordID = CKRecord.recordID
    }
    
    public func updateCKRecordLocally(record: inout CKRecord) {
        
        record[Quotewall.quotewallReferenceKey] = userReference as CKRecordValue?
        
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
