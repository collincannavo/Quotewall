//
//  Person.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import CloudKit

public class Person {
    
    public static let nameKey = "name"
    public static let recordTypeKey = "Person"
    public static let appleUserReferenceKey = "appleUserReference"
    public static let receivedQuotesKey = "receivedQuotes"
    
    public var ckRecordID: CKRecordID?
    public var userCKReference: CKReference?
    public let name: String
    public var receivedQuotes: [CKReference] = []
    public var personalQuotes: [Quote] = []
    public var quotes: [Quote] = []
    
    public var sortedPersonalQuotes: [Quote] {
        return personalQuotes.sorted(by: {$0.name.lowercased() < $1.name.lowercased() })
    }
    
    public var sortedQuotes: [Quote] {
        return quotes.sorted(by: {$0.name.lowercased() < $1.name.lowercased() })
    }
    
    public var ckReference: CKReference? {
        guard let ckRecordID = ckRecordID else { return nil }
        return CKReference(recordID: ckRecordID, action: .none)
    }
    
    public var ckRecord: CKRecord {
        let recordID = self.ckRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        let record = CKRecord(recordType: Person.recordTypeKey, recordID: recordID)
        record[Person.nameKey] = name as CKRecordValue?
        record[Person.appleUserReferenceKey] = userCKReference as CKRecordValue?
        
        if !receivedQuotes.isEmpty {
            record[Person.receivedQuotesKey] = receivedQuotes as CKRecordValue?
        }
        self.ckRecordID = recordID
        return record
    }
    
    public init(name: String, userCKReference: CKReference) {
        self.name = name
        self.userCKReference = userCKReference
    }
    
    public init?(CKRecord: CKRecord) {
        guard let name = CKRecord[Person.nameKey] as? String else { return nil }
        self.name = name
        self.userCKReference = CKRecord[Person.appleUserReferenceKey] as? CKReference
        
        let receivedQuotes = CKRecord[Person.receivedQuotesKey] as? [CKReference] ?? []
        self.receivedQuotes = receivedQuotes
        self.ckRecordID = CKRecord.recordID
    }
    
    public func updateCKRecordLocally(record: inout CKRecord) {
        record[Person.nameKey] = name as CKRecordValue?
        record[Person.appleUserReferenceKey] = userCKReference as CKRecordValue?
        
        if receivedQuotes.isEmpty {
            record[Person.receivedQuotesKey] = nil
        } else {
            record[Person.receivedQuotesKey] = receivedQuotes as CKRecordValue?
        }
    }
}


extension Person: Equatable {
    public static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name && lhs.ckRecordID == rhs.ckRecordID
    }
}
