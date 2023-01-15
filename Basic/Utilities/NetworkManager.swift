//
//  NewApiServiceAsync.swift
//  Basic
//
//  Created by Aviram Netanel on 02/12/2022.
//

import Foundation


protocol SessionProtocolAsync {
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: SessionProtocolAsync {
    
}

//Using structured concurrency (async/await)

typealias SessionResponse = (data: Data, urlResponse: URLResponse) 

class NetworkManager<JSONResponse: Decodable>{
    
    // This allows us to mock the network call and write unit tests for our API service
     let session: SessionProtocolAsync
    
    init(){
        session = URLSession.init(configuration: NetworkManager.setConfig())
    }
    
    init(session: SessionProtocolAsync) {
        self.session = session
    }
    
    func fetchData(withURL url: URL) async throws -> JSONResponse {
        print("_REQUEST: \(url.description)")
        let urlResponseWithData: SessionResponse = try await session.data(from: url, delegate: nil)
        return try JSONDecoder().decode(JSONResponse.self, from: urlResponseWithData.data)
    }
    
    static func setConfig() -> URLSessionConfiguration{
        let config = URLSessionConfiguration.default

        config.httpAdditionalHeaders = [
            "Accept": "application/json",
            "key": Constants.key
        ]
        return config
    }
}


