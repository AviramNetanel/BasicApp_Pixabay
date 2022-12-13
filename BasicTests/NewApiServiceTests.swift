//
//  NewApiServiceTests.swift
//  BasicTests
//
//  Created by Marat Ibragimov on 03/12/2022.
//

import XCTest
@testable import Basic

final class NewApiServiceTests: XCTestCase {
    
    
    let dummyURL = URL(string: "http://google.com")!
    let dummyURL2 = URL(string: "http://yahoo.com")!
    override func setUp() {
        super.setUp()
        
    }
    
    func testNoResponseError(){
        let mockedSession = MockURLSession()
        let apiService = NewApiService<HitResponseModel>(session: mockedSession)
        apiService.data(withURL: dummyURL) { result in
            switch result {
            case .success:
                XCTFail("A failure is expected")
            case let .failure(error):
                XCTAssertEqual(error as? TestErrors, .noResponseError)
            }
        }
    }
    
    func testResponseFromJsonFile() async throws{
        let data = FileDataReader().read(from: "Response", fileExtension: "json")
        let mockedSession = MockURLSession(result: .success(data))
        let apiService = NewApiService<HitResponseModel>(session: mockedSession)
        
        apiService.data(withURL: dummyURL) { result in
            switch result {
            case let .success(response):
                XCTAssertTrue(response.total != 0)
                XCTAssertTrue(response.totalHits != 0)
                XCTAssertTrue(response.hits.isEmpty == false)
            case .failure:
                XCTFail("Success case is expected")
            }
        }
    }
    
    
    func testResponseHttpError() async throws{
        let mockedSession = MockURLSession(result: .failure(TestErrors.httpError_200))
        let apiService = NewApiService<HitResponseModel>(session: mockedSession)
        
        apiService.data(withURL: dummyURL) { result in
            switch result {
            case .success(_):
                XCTFail("Error is expected")
            case let .failure(error):
                XCTAssertEqual(error as? TestErrors, .httpError_200)
            }
        }
    }
    
    
    func testResponse2() throws{
        let mockedSession = MockURLSession(result: .failure(TestErrors.httpError_200))
        let apiService = NewApiService<HitResponseModel>(session: mockedSession)
        
        apiService.data(withURL: dummyURL) { result in
            switch result {
            case .success(_):
                apiService.data(withURL: self.dummyURL2) { result in
                    switch result {
                    case .success:
                        return
                    case .failure:
                        return
                    }
                }
            case let .failure(error):
                XCTAssertEqual(error as? TestErrors, .httpError_200)
            }
        }
    }
    
    
    func testResponseAsync() async {
        let mockedSession = MockURLSession()
        let apiService = NetworkManager<HitResponseModel>(session: mockedSession)
        
        do {
            let response1 = try await apiService.fetchData(withURL: dummyURL)
            let response2 = try await apiService.fetchData(withURL: dummyURL2)
            
        } catch {
            print(error)
        }
        
    }
    
}
