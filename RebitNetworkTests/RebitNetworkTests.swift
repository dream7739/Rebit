//
//  RebitNetworkTests.swift
//  RebitNetworkTests
//
//  Created by 홍정민 on 10/21/24.
//

import XCTest
@testable import Rebit

final class RebitNetworkTests: XCTestCase {

    var sut: NetworkType!
    
    override func setUpWithError() throws {
        sut = MockAPIManager.shared
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testAPIManager_ValidISBN_ReturnSuccess() throws {
        
        let promise = expectation(description: "ISBN Await")
        
        Task {
            let result = try await sut.callRequest(request: BookRequest(query: "TEST"))
            XCTAssertGreaterThanOrEqual(result.items.first!.isbn.count, 10)
            XCTAssertLessThanOrEqual(result.items.first!.isbn.count, 13)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
