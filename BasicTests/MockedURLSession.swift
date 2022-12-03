//
//  MockedURLSession.swift
//  BasicTests
//
//  Created by Marat Ibragimov on 03/12/2022.
//

import Foundation
@testable import Basic

enum TestErrors: Error {
    case noResponseError
    case httpError_200
}

class MockURLSession {
    
    private var data: Data?
    private var error: Error?
    
    private let result:  Result<Data, Error>?
    init(result: Result<Data, Error>? = nil) {
        self.result = result
    }
}

extension MockURLSession: SessionProtocolAsync {
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        guard let result else {
            throw TestErrors.noResponseError
        }

        switch result {
        case let .failure(error):
            throw error
        case let .success(data):
            return (data, URLResponse())
        }

    }
}


typealias DataTaskCompletion = (Data?, URLResponse?, Error?) -> Void

class MockedDataTask: DataTaskProtocol {
    private let completion: DataTaskCompletion
    private var response: URLResponse?
    private let result:  Result<Data, Error>?
    init(result: Result<Data, Error>?, response: URLResponse?, completion: @escaping DataTaskCompletion) {
        self.result = result
        self.response = response
        self.completion = completion
    }
    
    func resume() {
        switch result {
        case  let .failure(error):
            completion(nil, response, error)
        case let .success(data):
            completion(data, response, nil)
        case .none:
            completion(nil, response, TestErrors.noResponseError)
        }
       
    }
}

extension MockURLSession: SessionProtocol {
    
    func task(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> Basic.DataTaskProtocol {
            MockedDataTask(result: result, response: URLResponse(), completion: completionHandler)
    }
}
