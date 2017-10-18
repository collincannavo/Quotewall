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
    public static let referenceKey = "sharedQuoteReference"
    public static let titleKey = "title"
    
    
    public var name: String
    public var quote: String
    public var title: String?
    public var backgroundImage: Data?
    public var contributor: String?
    
    public var ckRecordID: CKRecordID?
    
    public var ckRecord: CKRecord {
        let recordID = self.ckRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        let record = CKRecord(recordType: SharedQuote.recordTypeKey, recordID: recordID)
        
        record[SharedQuote.nameKey] = name as CKRecordValue?
        record[SharedQuote.referenceKey] = reference as CKRecordValue?
        record[SharedQuote.quoteKey] = quote as CKRecordValue?
        record[SharedQuote.titleKey] = title as CKRecordValue?
        
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
    
<<<<<<< HEAD
    public init(name: String, quote: String, title: String?, backgroundImage: Data? = nil) {
=======
    public init(name: String, quote: String, backgroundImage: Data? = nil, contributor: String? = "") {
>>>>>>> version2ID
        self.name = name
        self.quote = quote
        self.title = title
        self.backgroundImage = backgroundImage
        self.contributor = contributor
    }
    
    public convenience init?(ckRecord: CKRecord) {
        
        guard let name = ckRecord[SharedQuote.nameKey] as? String,
            let quote = ckRecord[SharedQuote.quoteKey] as? String,
            let title = ckRecord[SharedQuote.titleKey] as? String,
            let ckReference = ckRecord[SharedQuote.referenceKey] as? CKReference
            else { return nil }
        
        let backgroundImageAsset = ckRecord[SharedQuote.backgroundImageDataKey] as? CKAsset
        var backgroundImageData: Data?
        if let backgroundDataURL = backgroundImageAsset?.fileURL {
            backgroundImageData = try? Data(contentsOf: backgroundDataURL, options: .mappedIfSafe)
        }
        
        self.init(name: name, quote: quote, title: title, backgroundImage: backgroundImageData)
        
        self.reference = ckReference
        self.ckRecordID = ckRecord.recordID
        
    }
    
}

extension SharedQuote: Equatable {
    public static func ==(lhs: SharedQuote, rhs: SharedQuote) -> Bool {
        return lhs.name == rhs.name && lhs.ckRecordID == rhs.ckRecordID
    }
}
