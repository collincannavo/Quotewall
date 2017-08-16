//
//  NetworkController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/16/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation

class NetworkController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    static func performRequest(forURL url: URL,
                               withMethod httpMethod: HTTPMethod,
                               urlParameters: [String: String]? = nil,
                               body: Data? = nil,
                               completion: ((Data?, Error?) -> Void)? = nil) {
        
        let requestURL = self.getURL(byAddingParameters: urlParameters, toURL: url)
        var request = URLRequest(url: requestURL)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print(response)
            }
            
            completion?(data, error)
        }
        dataTask.resume()
    }
    
    static func getURL(byAddingParameters parameters: [String: String]?,
                       toURL url: URL) -> URL {
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters?.flatMap { URLQueryItem(name: $0.0, value: $0.1) }
        guard let url = components?.url else { fatalError("URL is nil") }
        return url
    }
}
