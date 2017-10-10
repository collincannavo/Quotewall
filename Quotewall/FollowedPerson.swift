//
//  FollowedPerson.swift
//  Quotewall
//
//  Created by Collin Cannavo on 10/9/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import CloudKit

public class FollowedPerson{
    
    public static let nameKey = "name"
    public static let phoneKey = "phone"
    public static let identifierKey = "identifier"
    public static let recordTypeKey = "FollowedPerson"
    public static let userReferenceKey = "FollowedPersonReference"
    
    
    public let name: String
    public let phone: [String]
    public let identifier: String
    public var ckRecordID: CKRecordID?
    public var userCKReference: CKReference?
    
    public init(name: String, phone: [String], identifier: String, userCKReference: CKReference) {
        self.name = name
        self.phone = phone
        self.identifier = identifier
        self.userCKReference = userCKReference
        
    }

    public var ckRecord: CKRecord {
        let recordID = self.ckRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        let record = CKRecord(recordType: FollowedPerson.recordTypeKey, recordID: recordID)
        record[FollowedPerson.nameKey] = name as CKRecordValue?
        record[FollowedPerson.phoneKey] = phone as CKRecordValue?
        record[FollowedPerson.identifierKey] = identifier as CKRecordValue?
        
        self.ckRecordID = recordID
        return record
    }
    
    public var parentCKReference: CKReference?
    
    public var ckReference: CKReference? {
        guard let ckRecordID = ckRecordID else { return nil }
        return CKReference(recordID: ckRecordID, action: .none)
    }
    
    public init?(CKrecord: CKRecord) {
        guard let name = CKrecord[FollowedPerson.nameKey] as? String,
            let phone = CKrecord[FollowedPerson.phoneKey] as? String ,
            let identifier = CKrecord[FollowedPerson.identifierKey] as? String
            else { return nil}
        
        self.name = name
        self.phone = [phone]
        self.identifier = identifier

        self.userCKReference = CKrecord[FollowedPerson.userReferenceKey] as? CKReference
        
        self.ckRecordID = CKrecord.recordID
    }
}

/*
 
 FollowedPerson created by CNContact and references the User.  The predicate looks for the phone number of the person after the User selects
 The shared quote wall looks for ANY shared quotes and only shows the ones from the followedPersons
 
 
 
 
 */
