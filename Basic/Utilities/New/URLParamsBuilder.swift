//
//  URLParamsBuilder.swift
//  Basic
//
//  Created by Aviram Netanel on 03/12/2022.
//

import Foundation


class URLParamsBuilder {
    
    private let baseURL: String
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    private var queryItems = [URLQueryItem]()
    func add(queryItem: URLQueryItem) {
        queryItems.append(queryItem)
    }
    
    func build() -> URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
}
