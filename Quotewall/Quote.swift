//
//  Quote.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import CloudKit


public class Quote {
    
    public static let nameKey = "name"
    public static let recordTypeKey = "Quote"
    public static let voteKey = "vote"
    public static let textKey = "text"
    public static let imageKey = "image"
    public static let ckRecordIDKey = "ckRecordID"
    public static let parentKey = "parent"
    
    public let name: String
    public let vote: Double?
    public let text: String
    public let image: Data?
    
    public init(name: String, vote: Double? = nil, text: String, image: Data? = nil) {
        self.name = name
        self.vote = vote
        self.text = text
        self.image = image
        
    }
    
    // MARK: - CloudKit Syncable
    
    public var ckRecordID: CKRecordID?
    
    public var ckReference: CKReference? {
        guard let ckRecordID = ckRecordID else { return nil }
        return CKReference(recordID: ckRecordID, action: .none)
    }
    
    public var parentCKRecordID: CKRecordID? {
        return parentCKReference?.recordID
    }
    
    public var parentCKReference: CKReference?
    
    public var quoteData: Data?
    
    public var ckRecord: CKRecord {
        let record = CKRecord(recordType: Quote.recordTypeKey)
        record.setValue(name, forKey: Quote.nameKey)
        record.setValue(vote, forKey: Quote.voteKey)
        record.setValue(text, forKey: Quote.textKey)
        record.setValue(image, forKey: Quote.imageKey)
        record.setValue(parentCKReference, forKey: Quote.parentKey)
        
        self.ckRecordID = record.recordID
        
        return record
    }
    
    public convenience init?(ckRecord: CKRecord) {
        
        guard let name = ckRecord[Quote.nameKey] as? String,
            let text = ckRecord[Quote.textKey] as? String
        else { return nil }
        
        let vote = ckRecord[Quote.voteKey] as? Double
        let parentCKReference = ckRecord[Quote.parentKey] as? CKReference
        let imageData = ckRecord[Quote.imageKey] as? Data
        let imageAsset = ckRecord[Quote.imageKey] as? CKAsset
        var newImageData: Data?
        if let imageDataURL = imageAsset?.fileURL {
            newImageData = try? Data(contentsOf: imageDataURL, options: .mappedIfSafe)
        }
        
        self.init(name: name, vote: vote, text: text, image: newImageData)
        
        if let imageDataUnwrapped = imageData {
            self.quoteData = imageDataUnwrapped
        }
        
        self.ckRecordID = ckRecord.recordID
        self.parentCKReference = parentCKReference
    }
    
    
}














