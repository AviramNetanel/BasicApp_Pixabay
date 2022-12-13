//
//  NewAsyncApiService.swift
//  BasicTests
//
//  Created by Marat Ibragimov on 03/12/2022.
//

import XCTest
@testable import Basic

final class NewAsyncApiServiceTests: XCTestCase {

    let urlDummyURL = URL(string: "http://google.com")!
    override func setUp() {
        super.setUp()
        
    }
    
    func testNoResponseError() async{
        let mockedSession = MockURLSession()
        let apiService = NetworkManager<HitResponseModel>(session: mockedSession)
        
        do {
            let _ : HitResponseModel = try await apiService.data(withURL: urlDummyURL)
            XCTFail("A failure is expected")
        } catch {
            XCTAssertEqual(error as? TestErrors, .noResponseError)
        }
    }
    
    
    func testResponseFromJsonFile() async throws{
        let data = FileDataReader().read(from: "Response", fileExtension: "json")
        let mockedSession = MockURLSession(result: .success(data))
        let apiService = NetworkManager<HitResponseModel>(session: mockedSession)
        let response = try await apiService.data(withURL: urlDummyURL)
        XCTAssertTrue(response.total != 0)
        XCTAssertTrue(response.totalHits != 0)
        XCTAssertTrue(response.hits.isEmpty == false )
    }
    
    func testResponseHttpError() async throws{
    
        let mockedSession = MockURLSession(result: .failure(TestErrors.httpError_200))
        let apiService = NewAsyncApiService<HitResponseModel>(session: mockedSession)
        do {
            let response = try await apiService.data(withURL: urlDummyURL)
        } catch {
            XCTAssertEqual(error as? TestErrors, .httpError_200)
        }
        
    }


}


