//===----------------------------------------------------------------------===//
//
// This source file is part of the JSONPatchSwift open source project.
//
// Copyright (c) 2015 EXXETA AG
// Licensed under Apache License v2.0
//
//
//===----------------------------------------------------------------------===//

import XCTest
@testable import JsonPatchSwift
import SwiftyJSON

// http://tools.ietf.org/html/rfc6902#section-4.2
// 4.  Operations
// 4.2.  remove
class JPSRemoveOperationTests: XCTestCase {

    func testIfDeleteLastElementReturnsEmptyJson() {
        let json = JSON(data: " { \"foo\" : \"1\" } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"remove\", \"path\": \"/foo\" }")
        let resultingJson = JPSJsonPatch.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: "{ }".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfDeleteSubElementReturnsEmptyTopElement() {
        let json = JSON(data: " { \"foo\" : { \"bar\" : \"1\" } } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"remove\", \"path\": \"/foo/bar\" }")
        let resultingJson = JPSJsonPatch.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: "{ \"foo\" : { } }".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfDeleteLastArrayElementReturnsEmptyArray() {
        let json = JSON(data: " { \"foo\" : { \"bar\" : \"1\" } } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"remove\", \"path\": \"/foo/bar\" }")
        let resultingJson = JPSJsonPatch.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: "{ \"foo\" : { } }".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfDeleteFromArrayDeletesTheExpectedKey() {
        let json = JSON(data: " [ \"foo\", 42, \"bar\" ] ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"remove\", \"path\": \"/2\" }")
        let resultingJson = JPSJsonPatch.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: " [ \"foo\", 42, ] ".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfDeleteFromMultiDimensionalArrayDeletesTheExpectedKey() {
        let json = JSON(data: " [ \"foo\", [ \"foo\", 3, \"42\" ], \"bar\" ] ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"remove\", \"path\": \"/1/2\" }")
        let resultingJson = JPSJsonPatch.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: " [ \"foo\", [ \"foo\", 3 ], \"bar\" ] ".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
}
