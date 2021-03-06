//
//  CloudKitController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

public class CloudKitController {
    
    public static let shared = CloudKitController()
    
    private let container = CKContainer(identifier: "iCloud.com.collincannavo.Quotewall")
    
    private var quotewall: Quotewall?
    
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
        
        container.publicCloudDatabase.save(record) { (record, error) in
            if let error = error {
                completion(record, error)
            }
            
            completion(record, error)
        }
    }
    
    public func fetchRecord(with recordID: CKRecordID, completion: @escaping(CKRecord?, Error?)-> Void) {
            container.publicCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
                completion(record, error)
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
        operation.completionBlock = completion
        self.container.publicCloudDatabase.add(operation)
        
        
    }
    
    public func createUser(with name: String, phone: String, completion: @escaping (_ success: Bool) -> Void ) {
        
        container.fetchUserRecordID { (record, error) in
            if let error = error { print(error.localizedDescription); completion(false); return }
            
            guard let appleUserRecordID = record else { completion(false); return }
            
            let userCKReference = CKReference(recordID: appleUserRecordID, action: .none)
            
            let user = Person(name: name, phone: phone, userCKReference: userCKReference)
            
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
            guard let appleUserRecordID = appleUserRecordID else {
                completion(false, nil); return }
            
            let appleUserReference = CKReference(recordID: appleUserRecordID, action: .none)
            
            let predicate = NSPredicate(format: "\(Person.appleUserReferenceKey) == %@", appleUserReference)
            
            let query = CKQuery(recordType: Person.recordTypeKey, predicate: predicate)
            
            self.container.publicCloudDatabase.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                if let error = error { print(error.localizedDescription);
                    completion(false, nil); return }
                
                guard let currentUserRecord = records?.first else {
                    completion(true, nil) ; return }
                
                let currentPerson = Person(CKRecord: currentUserRecord)
                
                PersonController.shared.currentPerson = currentPerson
                
                completion(true, currentPerson)
                
            })
        }
    }
    
    
    public func fetchCurrentQuotewall(completion: @escaping(Bool, Quotewall?) -> Void) {
            
            guard let currentUserRecordID = PersonController.shared.currentPerson?.ckRecordID
                else { completion(false, nil); return }
            
            let predicate = NSPredicate(format: "parentReference == %@", currentUserRecordID)
            
            let query = CKQuery(recordType: Quotewall.recordTypeKey, predicate: predicate)
            
            self.container.publicCloudDatabase.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                if let error = error { print(error.localizedDescription); completion(false, nil); return }
                
                guard let currentQuotewall = records?.first
                    else { completion(false, nil); return }
                
                let newCurrentQuotewall = Quotewall(CKRecord: currentQuotewall)
                
                QuotewallController.shared.currentQuotewall = newCurrentQuotewall
                
                completion(true, newCurrentQuotewall)
                
            })
        
    }
    
    public func fetchCurrentPersonQuotewalls(completion: @escaping (Bool, [Quotewall])-> Void) {
       
        guard let currentPersonID = PersonController.shared.currentPerson?.ckRecordID else { completion(false, []); return }
        
        let currentPersonCKReference = CKReference(recordID: currentPersonID, action: .none)
        
        let predicate = NSPredicate(format: "parentReference == %@", currentPersonCKReference)
        
        let query = CKQuery(recordType: Quotewall.recordTypeKey, predicate: predicate)
        
        container.publicCloudDatabase.perform(query, inZoneWith: nil) { (ckRecords, error) in
            if let error = error {
                NSLog("There was an error fetching current quotewalls: \(error.localizedDescription)")
                completion(false, [])
                return
            }
            
            guard let records = ckRecords else { return }
            
            let currentQuotewalls = records.flatMap({Quotewall(CKRecord: $0) })
            
            QuotewallController.shared.quotewalls = currentQuotewalls
            
            completion(true, currentQuotewalls)
            
        }
        
    }
    public func fetchCurrentQuotewallQuotes(completion: @escaping(Bool)-> Void) {
        
        guard let currentQuotewallID = QuotewallController.shared.currentQuotewall?.ckRecordID
            else { completion(false); return }
        
        let currentQuotewallCKReference = CKReference(recordID: currentQuotewallID, action: .none)
        
        let predicate = NSPredicate(format: "quotewallReference == %@", currentQuotewallCKReference)
        
        let query = CKQuery(recordType: Quote.recordTypeKey, predicate: predicate)
        
        container.publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                NSLog("There was an error fetching the current Quotewall's quotes: \(error.localizedDescription)")
            }
            
            guard let records = records,
                let currentQuotewall = QuotewallController.shared.currentQuotewall
            else { completion(false); return}
            
            let quotes = records.flatMap({Quote(ckRecord: $0)})
            
            currentQuotewall.quotes = quotes
            
            completion(true)
        }
        
    }
    
    public func fetchQuotesForQuotewall(_ quotewall: Quotewall, completion: @escaping (Bool, [Quote])-> Void) {
        
        guard let currentQuoteID = quotewall.ckReference
            else { completion(false, []); return }
        
        let predicate = NSPredicate(format: "quotewallReference == %@", currentQuoteID)
        
        let query = CKQuery(recordType: Quote.recordTypeKey, predicate: predicate)
        
        container.publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                NSLog("There was an error fetching quotes for the quotewall: \(error.localizedDescription)")
            }
            guard let records = records
                else { completion(false, []); return }
            
            let quotes = records.flatMap({Quote(ckRecord: $0)} )
            
            quotewall.quotes = quotes
            
            completion(true, quotes)
        }
 
    }
    
    
    public func fetchQuotewalls(completion: @escaping (Bool)-> Void) {

        guard let currentUsersID = PersonController.shared.currentPerson?.ckRecordID
            else { return }
        
        let reference = CKReference(recordID: currentUsersID, action: .none)
        
        let predicate = NSPredicate(format: "parentReference == %@", reference)
        
        let query = CKQuery(recordType: Quotewall.recordTypeKey, predicate: predicate)
        
        container.publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                NSLog("There was an error fetching quotewalls: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let records = records
                else { completion(false); return }
            
            let quotewalls = records.flatMap({Quotewall(CKRecord: $0)})
            
            QuotewallController.shared.quotewalls = quotewalls
            
            completion(true)
        }
    }
    
    public func fetchFavoriteQuotes(for person: Person, completion: @escaping(Bool, [FavoriteQuote]) -> Void) {
        
        guard let currentPersonID = PersonController.shared.currentPerson?.ckRecordID
            else { completion(false, []); return }
        
        let reference = CKReference(recordID: currentPersonID, action: .none)
        
        let predicate = NSPredicate(format: "favoriteQuoteReference == %@", reference)
        
        let query = CKQuery(recordType: FavoriteQuote.recordTypeKey, predicate: predicate)
        
        container.publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                NSLog("There was an error when fetching favorite quotes: \(error.localizedDescription)")
                completion(false, [])
                return
            }
        
            guard let records = records
                else { completion(false, []); return }
            
            let favoriteQuotes = records.flatMap({FavoriteQuote(ckRecord: $0)})
            
            person.favoriteQuotes = favoriteQuotes
            completion(true, favoriteQuotes)
        }
        
    }
    
    public func fetchSharedQuotes(for person: Person, completion: @escaping(Bool, [SharedQuote]) -> Void) {
        
        let predicate = NSPredicate(format: "sharedQuoteReference IN %@", person.followedUsers)
        
        let query = CKQuery(recordType: SharedQuote.recordTypeKey, predicate: predicate)
        
        container.publicCloudDatabase.perform(query, inZoneWith: nil) { (ckRecords, error) in
            if let error = error {
                NSLog("There was an error fetching all the shared quotes: \(error.localizedDescription)")
                completion(false, [])
                return
            }
            
            guard let records = ckRecords
            
                else { completion(false, []); return }
            
            let sharedQuotes = records.flatMap({SharedQuote(ckRecord: $0)})
            
            person.sharedQuotes = sharedQuotes
            
            completion(true, sharedQuotes)
            
        }
        
    }
    public func createFollowedUsers(with phone: String, completion: @escaping (Bool) -> Void) {
        
        let predicate = NSPredicate(format: "phone == %@", phone)
        
        let query = CKQuery(recordType: Person.recordTypeKey, predicate: predicate)
        
        container.publicCloudDatabase.perform(query, inZoneWith: nil) { (ckRecords, error) in
            if let error = error {
                NSLog("There was an error fetching a person to follow: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let record = ckRecords?.first,
                let person = PersonController.shared.currentPerson
                else
            { completion(false);
                return }
            
            let reference = CKReference(record: record, action: .none)
            
            person.followedUsers.append(reference)
            
            completion(true)
            
        }
    }
    
<<<<<<< HEAD
    public func updateQuoteRecord(with quote: Quote, completion: @escaping (Bool) -> Void) {
        let record = quote.ckRecord
        
        CloudKitController.shared.updateRecord(record) { (records, recordIDs, error) in
            if let error = error {
                NSLog("There was an error updating the Quote: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard (records?.first != nil) else { NSLog("Did not successfully return the modified quote record"); completion(false); return }
            
            completion(true)
        }
=======
//    public func createFollowedUserWithID(with identifier: String, phone: String, completion: @escaping (Bool) -> Void) {
//        let predicate = NSPredicate(format: "identifier == %@ AND phone == %@", [identifier, phone])
//
//        let query = CKQuery(recordType: Person.recordTypeKey, predicate: predicate)
//
//        container.publicCloudDatabase.perform(query, inZoneWith: nil) { (ckRecords, error) in
//            if let error = error {
//                NSLog("There was an error creating a person to follow: \(error.localizedDescription)")
//                completion(false)
//                return
//            }
//            guard let record = ckRecords?.first,
//            let person = PersonController.shared.currentPerson
//            else
//            {completion(false); return}
//
//            let reference = CKReference(record: record, action: .none)
//            person.followedUsers.append(reference)
//
//            completion(true)
//        }
//    }
    
    public func compressImage(named: String) -> UIImage {
        
        guard let oldImage = UIImage(contentsOfFile: named) else
        { return UIImage() }
        
        guard let imageData = UIImageJPEGRepresentation(oldImage, 0.025) else
        { return UIImage() }
        
       guard let image = UIImage(data: imageData) else
       { return UIImage() }
        return image
        
>>>>>>> version2ID
    }
}

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
