//
//  SavedQuotes.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/24/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

public class FavoriteQuote {
    
    public static let recordTypeKey = "SavedQuotes"
    public static let quoteKey = "quote"
    public static let nameKey = "name"
    public static let backgroundImageDataKey = "backgroundImageAsset"
    public static let ckRecordIDKey = "ckRecordID"
    public static let referenceKey = "reference"
    
    public var quote: String
    public var name: String
    public var backgroundImage: Data?
    
    // MARK: - CloudKit Transitions
    
    public var ckRecordID: CKRecordID?
    
    public var ckReference: CKReference? {
        guard let ckRecordID = ckRecordID else { return nil }
        
        return CKReference(recordID: ckRecordID, action: .none)
    }
    
    public var reference: CKReference?
    
    public var ckRecord: CKRecord {
        let record = CKRecord(recordType: FavoriteQuote.recordTypeKey)
        record.setValue(name, forKey: FavoriteQuote.nameKey)
        record.setValue(quote, forKey: FavoriteQuote.quoteKey)
        
        let backgroundImageAsset = QuotewallController.shared.createCKAsset(for: backgroundImage)
        record.setValue(backgroundImageAsset, forKey: FavoriteQuote.backgroundImageDataKey)
        record.setValue(ckReference, forKey: FavoriteQuote.referenceKey)
        self.ckRecordID = record.recordID
        
        return record
    }
    
    public init(name: String, quote: String, backgroundImage: Data? = nil) {
        self.name = name
        self.quote = quote
        self.backgroundImage = backgroundImage
    }
    
    public convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[FavoriteQuote.nameKey] as? String,
            let quote = ckRecord[FavoriteQuote.quoteKey] as? String
        else { return nil }
        let ckReference = ckRecord[FavoriteQuote.referenceKey] as? CKReference
        let backgroundImageAsset = ckRecord[FavoriteQuote.backgroundImageDataKey] as? CKAsset
        var backgroundImageData: Data?
        if let backgroundDataURL = backgroundImageAsset?.fileURL {
            backgroundImageData = try? Data(contentsOf: backgroundDataURL, options: .mappedIfSafe)
        }
        
        self.init(name: name, quote: quote, backgroundImage: backgroundImageData)
        
        self.reference = ckReference
        self.ckRecordID = ckRecord.recordID
        
    }
    
    
    
    
    
    
}







