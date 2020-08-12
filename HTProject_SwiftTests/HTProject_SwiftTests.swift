//
//  HTProject_SwiftTests.swift
//  HTProject_SwiftTests
//
//  Created by Hem1ngT4i on 2020/7/22.
//  Copyright © 2020 Hem1ngT4i. All rights reserved.
//

import XCTest
@testable import HTProject_Swift

class HTProject_SwiftTests: XCTestCase {

    var f1 = 0
    var f2 = 0
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        f1 = 10
        f2 = 20
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(f1 + f2 == 30)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
