//
//  NetworkQuotes.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/16/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit


class NetworkQuotes {
    
    private let authorKey = "author"
    private let quoteKey = "quote"
    private let categoryKey = "category"
    
    let author: String
    let quote: String
    let category: String
    
    init?(dictionary: [String: String]) {
        guard let author = dictionary[authorKey],
            let quote = dictionary[quoteKey],
            let category = dictionary[categoryKey]
            else { return nil }
        
        self.author = author
        self.quote = quote
        self.category = category
        
    }
}
