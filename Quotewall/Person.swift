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
    public static let parentCKReferenceKey = "parentReference"
    public static let phoneKey = "phone"
    public static let followedUsersNamesKey = "followedUsers"
    
    public var ckRecordID: CKRecordID?
    public var userCKReference: CKReference?
    public let name: String
    public let phone: String
    public var personalQuotes: [Quote] = []
    public var quotes: [Quote] = []
    public var favoriteQuotes: [FavoriteQuote] = []
    public var followedUserNames: [CNContact] = []
    public var followedUsers: [CKReference] = []
    public var sharedQuotes: [SharedQuote] = []
    
    public var sortedPersonalQuotes: [Quote] {
        return personalQuotes.sorted(by: {$0.name.lowercased() < $1.name.lowercased() })
    }
    
    public var sortedQuotes: [Quote] {
        return quotes.sorted(by: {$0.name.lowercased() < $1.name.lowercased() })
    }
    
    public var parentCKReference: CKReference?
    
    public var ckReference: CKReference? {
        guard let ckRecordID = ckRecordID else { return nil }
        return CKReference(recordID: ckRecordID, action: .none)
    }
    
    public var ckRecord: CKRecord {
        let recordID = self.ckRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        let record = CKRecord(recordType: Person.recordTypeKey, recordID: recordID)
        record[Person.nameKey] = name as CKRecordValue?
//        record[Person.followedUsersNamesKey] = followedUserNames as CKRecordValue?
        record[Person.appleUserReferenceKey] = userCKReference as CKRecordValue?
        record[Person.phoneKey] = phone as CKRecordValue?
        
        self.ckRecordID = recordID
        return record
    }
    
    public init(name: String, phone: String, userCKReference: CKReference) {
        self.name = name
        self.userCKReference = userCKReference
        self.phone = phone
    }
    
    public init?(CKRecord: CKRecord) {
        guard let name = CKRecord[Person.nameKey] as? String,
            let phone = CKRecord[Person.phoneKey] as? String
//            let followedUsers = CKRecord[Person.followedUsersNamesKey] as? CNContact
        else { return nil }
        self.name = name
//        self.followedUserNames = followedUsers
        self.phone = phone
        self.userCKReference = CKRecord[Person.appleUserReferenceKey] as? CKReference
    
        self.ckRecordID = CKRecord.recordID
    }
    
    public func updateCKRecordLocally(record: inout CKRecord) {
        record[Person.nameKey] = name as CKRecordValue?
        record[Person.appleUserReferenceKey] = userCKReference as CKRecordValue?
        
    }
}


extension Person: Equatable {
    public static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name && lhs.ckRecordID == rhs.ckRecordID
    }
}
