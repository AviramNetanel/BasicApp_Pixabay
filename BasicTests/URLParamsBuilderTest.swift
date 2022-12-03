//
//  BasicTests.swift
//  BasicTests
//
//  Created by Marat Ibragimov on 03/12/2022.
//

import XCTest
@testable import Basic
final class URLParamsBuilderTest: XCTestCase {

    
    func testBuildsURL() {
        
        let urlBuilder = URLParamsBuilder(baseURL: "http://google.com")
        urlBuilder.add(queryItem: .init(name: "q", value: "someQuery"))
        urlBuilder.add(queryItem: .init(name: "key", value: "1234"))
        urlBuilder.add(queryItem: .init(name: "category", value: "someCategory"))
        urlBuilder.add(queryItem: .init(name: "per_page", value: "50"))
        let url = urlBuilder.build()
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "http://google.com?q=someQuery&key=1234&category=someCategory&per_page=50")
    }
    
    func testEncodesURL() {
        
        let urlBuilder = URLParamsBuilder(baseURL: "http://google.com")
        urlBuilder.add(queryItem: .init(name: "q", value: "some query"))
        urlBuilder.add(queryItem: .init(name: "key", value: "1234"))
        urlBuilder.add(queryItem: .init(name: "category", value: "some category"))
        urlBuilder.add(queryItem: .init(name: "per_page", value: "50"))
        let url = urlBuilder.build()
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "http://google.com?q=some%20query&key=1234&category=some%20category&per_page=50")
    }


}
