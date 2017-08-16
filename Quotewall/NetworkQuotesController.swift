//
//  NetworkQuotesController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/16/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit


class NetworkQuotesController {
    
    static let baseURL = URL(string: "https://andruxnet-random-famous-quotes.p.mashape.com/")
    
    static func fetchQuote(with text: String, completion: @escaping (Quote?) -> Void) {
        guard let url = baseURL else { completion(nil); return }
        
        let searchURL = url.appendingPathComponent(text)
        
        var request = URLRequest(url: searchURL)
        
        NetworkController.getURL(byAddingParameters: <#T##[String : String]?#>, toURL: <#T##URL#>)
        
        
        
    }
    
    
}
