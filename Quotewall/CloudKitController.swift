//
//  CloudKitController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import CloudKit

public class CloudKitController {
    
    public static let shared = CloudKitController()
    
    private let container = CKContainer(identifier: "iCloud.com.collin-cannavo.Quotewall")
    
    public func verifyCloudKitLogin(with completion: @escaping (Bool) -> Void) {
        container.status(forApplicationPermission: .userDiscoverability) { (permissionStatus, error) in
            if let error = error {
                NSLog("There was an error:\(error.localizedDescription) ")
                completion(false)
                return
            }
            
            if permissionStatus == .couldNotComplete {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    public func save(record: CKRecord, witCompletion completion: @escaping (CKRecord?, Error?) -> Void) {
        print("Going to the cloud")
        container.publicCloudDatabase.save(record) { (record, error) in
            if let error = error {
                completion(record, error)
            }
        }
        
    }
    
    public func fetchRecord(with recordID: CKRecordID, completion: @escaping(CKRecord?, Error?)-> Void) {
            container.publicCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
                completion(record, error)
            }
            
        }
    public func performQuery(with predicate: NSPredicate, completion: @escaping([CKRecord]?, Error?) -> Void) {
            
            let query = CKQuery(recordType: Quote.recordTypeKey, predicate: predicate)
            
            container.publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
                guard let record = records else { return }
                completion(record,error)
            }
        }
    public func updateRecord(_ record: CKRecord, with completion: @escaping([CKRecord]?, [CKRecordID]?, Error?)-> Void) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        
        self.container.publicCloudDatabase.add(operation)
    }
    
    public func deleteRecord(_ recordID: CKRecordID, with completion: @escaping()-> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [recordID])
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        
        self.container.publicCloudDatabase.add(operation)
        
    }
    
    public func createUser(with name: String, completion: @escaping (_ success: Bool) -> Void ) {
        
        container.fetchUserRecordID { (record, error) in
            if let error = error { print(error.localizedDescription); completion(false); return }
            
            guard let appleUserRecordID = record else { completion(false); return }
            
            let userCKReference = CKReference(recordID: appleUserRecordID, action: .none)
            
            let user = Person(name: name, userCKReference: userCKReference)
            
            self.container.publicCloudDatabase.save(user.ckRecord, completionHandler: { (_, error) in
                if let error = error { print(error.localizedDescription); completion(false); return }
                
                PersonController.shared.currentPerson = user
                
                completion(true)
            })
        }
    }
    
    public func fetchCurrentUser(completion: @escaping(Bool, Person?) -> Void) {
        container.fetchUserRecordID { (appleUserRecordID, error) in
            if let error = error {
                NSLog("There was an error fetching the current user: \(error.localizedDescription)")
                completion(false, nil)
                return }
            guard let appleUserRecordID = appleUserRecordID else { completion(false, nil); return }
            
            let appleUserReference = CKReference(recordID: appleUserRecordID, action: .none)
            
            let predicate = NSPredicate(format: "\(Person.appleUserReferenceKey) == &@", appleUserReference)
            
            let query = CKQuery(recordType: Person.recordTypeKey, predicate: predicate)
            
            self.container.publicCloudDatabase.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                if let error = error { print(error.localizedDescription); completion(false, nil); return }
                
                guard let currentUserRecord = records?.first else { completion(false, nil); return }
                
                let currentPerson = Person(CKRecord: currentUserRecord)
                
                PersonController.shared.currentPerson = currentPerson
                
                completion(true, currentPerson)
                
            })
        }
    }
    
    public func fetchAllQuotes(for records: [CKRecordID], with completion: @escaping ([CKRecordID: CKRecord]?, Error?) -> Void) {
        
        let fetchOperation = CKFetchRecordsOperation(recordIDs: records)
        fetchOperation.qualityOfService = .userInitiated
        fetchOperation.queuePriority = .high
        fetchOperation.fetchRecordsCompletionBlock = completion
        container.publicCloudDatabase.add(fetchOperation)
    }
    
   

}













