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
    
    
    public let name: String
    public let phone: String
    public let identifier: String
    public var ckRecordID: CKRecordID?
    public var userCKReference: CKReference?
    
    public init(name: String, phone: String, identifier: String, userCKReference: CKReference) {
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
    
    
}

/*
 
 FollowedPerson created by CNContact and references the User.
 
 
 
 
 */
