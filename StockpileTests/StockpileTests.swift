//
//  StockpileTests.swift
//  StockpileTests
//
//  Created by Chris Paine on 4/4/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import XCTest
@testable import Stockpile

class StockpileTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodeJSONAsPhotosResults() {
        if let url = Bundle(for: StockpileTests.self).url(forResource: "Photos", withExtension: "json"),
            let data = try? Data(contentsOf: url) {
            XCTAssertNoThrow(try JSONDecoder().decode(PhotoResults.self, from: data))
        } else {
            XCTFail()
        }
    }
    
    func testDecodeJSONAsCollectionResults() {
        if let url = Bundle(for: StockpileTests.self).url(forResource: "Collections", withExtension: "json"),
            let data = try? Data(contentsOf: url) {
            XCTAssertNoThrow(try JSONDecoder().decode(CollectionResults.self, from: data))
        } else {
            XCTFail()
        }
    }
}
