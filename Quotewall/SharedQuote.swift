//
//  SharedQuote.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/29/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit
import CloudKit


public class SharedQuote {
    
    public static let recordTypeKey = "SharedQuote"
    public static let nameKey = "name"
    public static let quoteKey = "quote"
    public static let backgroundImageDataKey = "backgroundImageAsset"
    public static let ckRecordIDKey = "CKRecordID"
    public static let referenceKey = "reference"
    
    
    public var name: String
    public var quote: String
    public var backgroundImage: Data?
    
    public var ckRecordID: CKRecordID?
    
    public var ckRecord: CKRecord {
        let recordID = self.ckRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        let record = CKRecord(recordType: FavoriteQuote.recordTypeKey, recordID: recordID)
        
        record[SharedQuote.nameKey] = name as CKRecordValue?
        record[SharedQuote.referenceKey] = reference as CKRecordValue?
        record[SharedQuote.quoteKey] = quote as CKRecordValue?
        
        let backgroundImageAsset = QuotewallController.shared.createCKAsset(for: backgroundImage)
        
        record.setValue(backgroundImageAsset, forKey: SharedQuote.backgroundImageDataKey)
        
        self.ckRecordID = recordID
        
        return record
    }

    
    public var ckReference: CKReference? {
        guard let ckRecordID = ckRecordID else { return nil }
        
        return CKReference(recordID: ckRecordID, action: .none)
    }
    
    public var reference: CKReference?

    // MARK: - CloudKit initializers
    
    public init(name: String, quote: String, backgroundImage: Data? = nil) {
        self.name = name
        self.quote = quote
        self.backgroundImage = backgroundImage
    }
    
    public convenience init?(ckRecord: CKRecord) {
        
        guard let name = ckRecord[SharedQuote.nameKey] as? String,
            let quote = ckRecord[SharedQuote.quoteKey] as? String,
            let ckReference = ckRecord[SharedQuote.referenceKey] as? CKReference
            else { return nil }
        
        let backgroundImageAsset = ckRecord[SharedQuote.backgroundImageDataKey] as? CKAsset
        var backgroundImageData: Data?
        if let backgroundDataURL = backgroundImageAsset?.fileURL {
            backgroundImageData = try? Data(contentsOf: backgroundDataURL, options: .mappedIfSafe)
        }
        
        self.init(name: name, quote: quote, backgroundImage: backgroundImageData)
        
        self.reference = ckReference
        self.ckRecordID = ckRecord.recordID
        
    }
    
}
