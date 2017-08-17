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
    
    var quotes: [NetworkQuotes] = []
    
    static func fetchQuote(with text: String, completion: @escaping ([NetworkQuotes]?) -> Void) {
        guard let url = baseURL else { completion(nil); return }
        
        let searchURL = url.appendingPathComponent(text)
        
       
        let jsonHeader: [String: String] = ["X-Mashape-Key": "KWMaTjg8tXmshPlW12ZdsFf9jvOqp19FWGsjsnKHVoG3ZcqO6H", "application": "json"]
        
        var request = URLRequest(url: searchURL)
        
        request.allHTTPHeaderFields = jsonHeader
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            
            if let error = error {
                
                NSLog("There was error: \(error.localizedDescription)")
                //            completion([])
                return
            }
            
            guard let data = data,
                let responseDataString = String(data: data, encoding: .utf8) else { return print("No data returned") }
            
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : String] else {
                print("Error decoding json: \(responseDataString)")
                return
                
            }
            
            guard let networkQuotes = NetworkQuotes(dictionary: jsonDictionary) else { return }
            
            completion([networkQuotes])
            
        }
        dataTask.resume()
        
    }
    
}










