//
//  URLParamsBuilder.swift
//  Basic
//
//  Created by Aviram Netanel on 03/12/2022.
//

import Foundation


struct URLParamsBuilder {
    
    var urlComponents : URLComponents?
    var queryItems: [URLQueryItem] = []
    var key : String?
    
    init(urlString: String){
        self.urlComponents = URLComponents(string: urlString)
        self.key = Constants.key
        self.queryItems = [URLQueryItem(name: "key", value: self.key)]
    }
    
    init(urlString: String, optionalParameters: [String: String] = [:]){
        self.urlComponents = URLComponents(string: urlString)
        self.key = Constants.key
        self.queryItems = [URLQueryItem(name: "key", value: self.key)]
        self.queryItems.append(contentsOf: optionalParameters.map {
            return URLQueryItem(name: $0, value: $1)})
            
        self.urlComponents?.queryItems = queryItems
    }
}
