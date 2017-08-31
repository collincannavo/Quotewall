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
    public static let receivedQuotesKey = "receivedQuotes"
    public static let recordTypeKey = "Quotewall"
    public static let backgroundImage = "backgroundImage"
    public static let quotewallReferenceKey = "quotewallReference"
    public static let parentUserReferenceKey = "parentReference"
    
    public var ckRecordID: CKRecordID?
    public var userReference: CKReference?
    public var parentReference: CKReference?
    public var category: String
    public var backgroundImage: Data?
    public var savedQuotewalls: [Quotewall] = []
    
    public var sortedQuotewalls: [Quotewall] {
        return savedQuotewalls.sorted(by: { $0.category.lowercased() < $1.category.lowercased()})
    }
 
    public var quotes: [Quote] = []
    
    public var sortedQuotes: [Quote] {
        return quotes.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
    }
    
    public var parentKey: CKReference?
    
    public var ckReference: CKReference? {
        guard let ckRecordID = self.ckRecordID else { return nil }
        return CKReference(recordID: ckRecordID, action: .none)
    }
    
    public var CKrecord: CKRecord {
        let recordID = self.ckRecordID ?? CKRecordID(recordName: UUID().uuidString)
       
        let record = CKRecord(recordType: Quotewall.recordTypeKey, recordID: recordID)
        record[Quotewall.categoryKey] = category as CKRecordValue?
        record[Quotewall.backgroundImage] = backgroundImage as CKRecordValue?
        record[Quotewall.parentUserReferenceKey] = userReference as CKRecordValue?

        self.ckRecordID = recordID
        return record
    }
    
    public init(userCKReference: CKReference, category: String, backgroundImage: Data? = nil) {
        self.userReference = userCKReference
        self.category = category
        self.backgroundImage = backgroundImage
        
    }
    
    public init?(CKRecord: CKRecord) {
        
        guard let category = CKRecord[Quotewall.categoryKey] as? String,
            let userReference = CKRecord[Person.parentCKReferenceKey] as? CKReference
        else { return nil }
        
        self.category = category
        self.parentReference = userReference
        
        self.ckRecordID = CKRecord.recordID
    }
    
}

extension Quotewall: Equatable {
    public static func ==(lhs: Quotewall, rhs: Quotewall) -> Bool {
        return lhs.category == rhs.category && lhs.ckRecordID == rhs.ckRecordID
    }
}
