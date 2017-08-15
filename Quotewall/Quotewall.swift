//
//  Quotewall.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import CloudKit

class Quotewall {
    
    public static let nameKey = "name"
    public static let categoryKey = "category"
    public static let quoteCountKey = "count"
    public static let appleUserReferenceKey = "appleUserReference"
    public static let receivedQuotesKey = "receivedQuotes"
    
    public var ckRecordID: CKRecordID?
    public var userReference: CKReference?
    public let name: String
    public let category: String
    public var quoteCount: Double
    public var receivedQuotes: [CKReference] = []
    public var personalQuotes: [CKReference] = []
    public var quotes: [Quote] = []
    
    public let initialQuotesFetchComplete = false
    public let intialPersonalQuotesFetchComplete = false
    
    init(name: String, category: String, quoteCount: Double) {
        self.name = name
        self.category = category
        self.quoteCount = quoteCount
        
    }
    
    public init(name: String, userCKReference: CKReference) {
        self.name = name
        self.userReference = userCKReference
    }
    
    public init?(CKRecord: CKRecord) {
        guard let name = CKRecord[Quotewall.nameKey] as? String else { return nil }
        self.name = name
        
        self.userReference = CKRecord[Quotewall.appleUserReferenceKey] as? CKReference
        
        let receivedQuotes = CKRecord[Quotewall.receivedQuotesKey] as? [CKReference] ?? []
        self.receivedQuotes = receivedQuotes
        
        self.ckRecordID = CKRecord.recordID
    }
    
    public func updateCKRecordLocally(record: inout CKRecord) {
        record[Quotewall.nameKey] = name as CKRecordValue?
        record[Quotewall.appleUserReferenceKey] = userReference as CKRecordValue?
        
        if receivedQuotes.isEmpty {
            record[Quotewall.receivedQuotesKey] = nil
        } else {
            record[Quotewall.receivedQuotesKey] = receivedQuotes as CKRecordValue?
        }
    }
    
}
