//
//  BitcoinTickerTests.swift
//  BitcoinTickerTests
//
//  Created by Goutham on 6/29/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import XCTest
@testable import BitcoinTicker

class BitcoinTickerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testLabel() {
        // Given
//        let app = XCUIApplication()
//        let labelText = app.staticTexts["bitcoinPriceLabel"]
//        // When
//        XCTAssertEqual(labelText.label, "Price")
        // Then
        
        
    }
    func testNetwork(){
        let baseURL = URL(string: "https://apiv2.bitcoinaverage.com")
        let session = URLSession(configuration: .default)
        let promise = expectation(description: "Response : 200")
        
        let task = session.dataTask(with: baseURL!){ (data, response, error) in
            guard error == nil else {
                XCTAssert(false, "There was a network error")
                return
            }
            if let status = (response as? HTTPURLResponse)?.statusCode {
                // then
                if status == 200 {
                    promise.fulfill()
                } else {
                    XCTAssert(false, "The response code returned was : \(status)")
                }
            }
            
        }
        task.resume()
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}
