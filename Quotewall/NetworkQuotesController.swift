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
       
        let jsonHeader: [String: String] = ["X-Mashape-Key": "KWMaTjg8tXmshPlW12ZdsFf9jvOqp19FWGsjsnKHVoG3ZcqO6H", "application": "json"]
        
        var request = URLRequest(url: searchURL)
        
        request.allHTTPHeaderFields = jsonHeader
        
       let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
       
        if let response = response {
        
            print(response)
            
            }
        
        if let error = error {
            
            NSLog("There was error: \(error.localizedDescription)")
        }
//            completion(data)
        }
        
        dataTask.resume()
    }
    
}
