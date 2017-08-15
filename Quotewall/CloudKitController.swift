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
        container.publicCloudDatabase.save(record) { (record, error) in
            if let error = error {
                completion(record, error)
            }
        }
        
    
    }
    
    
}
