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
        
        let urlParameters = ["cat": text, "count": "10"]
       
        let jsonHeader: [String: String] = ["X-Mashape-Key": "KWMaTjg8tXmshPlW12ZdsFf9jvOqp19FWGsjsnKHVoG3ZcqO6H", "application": "json"]
        
        var request = URLRequest(url: url)
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = urlParameters.flatMap { URLQueryItem(name: $0.0, value: $0.1) }
        guard let searchURL = components?.url else { fatalError("URL is nil") }

        request.url = searchURL
        request.allHTTPHeaderFields = jsonHeader
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            
            if let error = error {
                
                NSLog("There was error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data,
                let responseDataString = String(data: data, encoding: .utf8) else { return print("No data returned") }
            
            guard let jsonArray = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [[String : String]] else {
                print("Error decoding json: \(responseDataString)")
                return
                
            }
            var arrayOfQuotes: [NetworkQuotes] = []
            
            for dictionary in jsonArray {
                
                guard let networkQuotes = NetworkQuotes(dictionary: dictionary) else { return }
                
                arrayOfQuotes.append(networkQuotes)
            }
            
            completion(arrayOfQuotes)
            
        }
        dataTask.resume()
        
    }
    
}










