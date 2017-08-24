//
//  Quote.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit
import CloudKit


public class Quote {
    
    public static let nameKey = "name"
    public static let recordTypeKey = "Quote"
    public static let voteKey = "vote"
    public static let textKey = "text"
    public static let imageKey = "image"
    public static let ckRecordIDKey = "ckRecordID"
    public static let quotewallReferenceKey = "quotewallReference"
    public static let imageDataKey = "imageAsset"
    
    
    public var name: String
    public var vote: Double?
    public var text: String
    public var image: Data?
    public var ckRecordID: CKRecordID?
    public var quotewallReference: CKReference?
    public var quotes: [Quote] = []
    
    public init(name: String, text: String, image: Data? = nil, quotewallReference: CKReference?) {
        self.name = name
        self.text = text
        self.image = image
        self.quotewallReference = quotewallReference
        
    }
    
    // MARK: - CloudKit Syncable
    
    public var ckReference: CKReference? {
        guard let ckRecordID = ckRecordID else { return nil }
        return CKReference(recordID: ckRecordID, action: .none)
    }
    public var sortedPersonalQuote: [Quote] {
        return quotes.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
    }
    
    public var parentCKRecordID: CKRecordID? {
        return parentCKReference?.recordID
    }
    
    public var parentCKReference: CKReference?
    
    public var quoteData: Data?
    
    public var ckRecord: CKRecord {
        let recordID = self.ckRecordID ?? CKRecordID(recordName: UUID().uuidString)
        let record = CKRecord(recordType: Quote.recordTypeKey, recordID: recordID)
        record.setValue(name, forKey: Quote.nameKey)
        record.setValue(text, forKey: Quote.textKey)
        let imageDataAsset = QuotewallController.shared.createCKAsset(for: image)
        record.setValue(imageDataAsset, forKey: Quote.imageDataKey)
        record[Quotewall.quotewallReferenceKey] = quotewallReference as CKRecordValue?
        
        self.ckRecordID = record.recordID
        
        return record
    }
    
    public convenience init?(ckRecord: CKRecord) {
        
        guard let name = ckRecord[Quote.nameKey] as? String,
            let text = ckRecord[Quote.textKey] as? String,
            let userCKReference = ckRecord[Quotewall.quotewallReferenceKey] as? CKReference
        else { return nil }
        
        let imageAsset = ckRecord[Quote.imageDataKey] as? CKAsset
        var newImageData: Data?
        if let imageDataURL = imageAsset?.fileURL {
            newImageData = try? Data(contentsOf: imageDataURL, options: .mappedIfSafe)
        }
        
        self.init(name: name, text: text, image: newImageData, quotewallReference: userCKReference)
        
        self.ckRecordID = ckRecord.recordID
        
    }

}

func ==(lhs: Quote, rhs: Quote) -> Bool {
    if lhs.name != rhs.name { return false }
    if lhs.image != rhs.image { return false }
    if lhs.text != rhs.text { return false }
    if lhs.quoteData != rhs.quoteData { return false }

    return true
    
}















