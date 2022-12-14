//
//  NewApiService.swift
//  Basic
//
//  Created by Aviram Netanel on 02/12/2022.
//

import Foundation


protocol SessionProtocol {
    func task(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> DataTaskProtocol
}

protocol DataTaskProtocol {
    func resume()
}

extension URLSession: SessionProtocol { // have to make this conformance so that you can inject URLSession in your production code and MockedURLSession in your unit tests
    func task(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> DataTaskProtocol {
        dataTask(with: url, completionHandler: completionHandler)
    }
}
extension URLSessionDataTask: DataTaskProtocol {} // The same for URLSessionDataTask


// FIRST IMPLEMENTATION: traditional usage of URLSession with completion blocks

class NewApiService<JSONResponse: Decodable> {
    
    private let session: SessionProtocol // This allows us to mock the network call and write unit tests for our API service
    init(session: SessionProtocol) {
        self.session = session
    }
    
    func data(withURL url: URL, completion: @escaping (Result<JSONResponse, Error>) -> Void) {
   
        session.task(with: url) { (data, response, error) in
            guard error == nil else { return }

            guard let data = data else { return }
               do {

                   let response = try JSONDecoder().decode(JSONResponse.self, from: data)
                   completion(.success(response))
              } catch let error {
                  return completion(.failure(error))
              }
        }.resume()
        
        
    }
}

