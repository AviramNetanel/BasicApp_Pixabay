//
//  NewApiServiceAsync.swift
//  Basic
//
//  Created by Marat Ibragimov on 02/12/2022.
//

import Foundation


protocol SessionProtocolAsync {
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: SessionProtocolAsync {}

// SECOND IMPLEMENTATION: Using structured concurrency (async/await)

typealias SessionResponse = (data: Data, urlResponse: URLResponse)

class NewAsyncApiService<JSONResponse: Decodable>{
    private let session: SessionProtocolAsync // This allows us to mock the network call and write unit tests for our API service
    init(session: SessionProtocolAsync) {
        self.session = session
    }
    
    
    func data(withURL url: URL) async throws -> JSONResponse {
        let urlResponseWithData: SessionResponse = try await session.data(from: url,
                                                                          delegate: nil)
        return try JSONDecoder().decode(JSONResponse.self, from: urlResponseWithData.data)
    }
    
}
