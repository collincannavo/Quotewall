//
//  NetworkQuotes.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/16/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit


struct NetworkQuotes {
    
   
    let author: String
    let quote: String
    let category: String
    
    init(author: String, quote: String, category: String = UUID().uuidString) {
        self.author = author
        self.quote = quote
        self.category = category
    }
    
}

// MARK: - JSON Conversion

extension NetworkQuotes {
    private static let authorKey = "author"
    private static let quoteKey = "quote"
    private static let categoryKey = "category"
    
    init?(dictionary: [String: String]) {
        guard let author = dictionary[NetworkQuotes.authorKey],
            let quote = dictionary[NetworkQuotes.quoteKey],
            let category = dictionary[NetworkQuotes.categoryKey]
            
            else { return nil }
        
        self.init(author: author, quote: quote, category: category)
    }
    
    var dictionaryRepresentation: [String:String] {
        
        return [NetworkQuotes.authorKey: author, NetworkQuotes.quoteKey: quote, NetworkQuotes.categoryKey: category]
    }
    
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: dictionaryRepresentation, options: .prettyPrinted)
    }
    
}















