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

// http://tools.ietf.org/html/rfc6902#section-4.1
// 4.  Operations
// 4.1.  add

class JPSAddOperationTests: XCTestCase {
    
    func testIfPathToArrayInsertsValueAtPositionAndShiftsRemainingMembersRight() {
        XCTFail("Yet to be implemented.")
    }

    func testIfPathToNonExistingMemberCreatesNewMember() {
        let json = JSON(data: " { \"foo\" : \"bar\" } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/bar\", \"value\": \"foo\" }")
        let resultingJson = JPSJsonPatch.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: "{ \"foo\" : \"bar\", \"bar\" : \"foo\" }".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfPathToExistingMemberReplacesIt() {
        let json = JSON(data: " { \"foo\" : \"bar\" } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/foo\", \"value\": \"foobar\" }")
        let resultingJson = JPSJsonPatch.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: "{ \"foo\" : \"foobar\" }".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfPathToRootReplacesWholeDocument() {
        let json = JSON(data: " { \"foo\" : \"bar\" } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"\", \"value\": { \"bar\" : \"foo\" } }")
        let resultingJson = JPSJsonPatch.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: "{ \"bar\" : \"foo\" }".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testAddToArrayWithIndexOutOfBoundsProducesError() {
        XCTFail("Yet to be implemented.")
    }
    
    func testIfMinusAtEndOfPathAppendsToArray() {
        let json = JSON(data: " { \"foo\" : [ bar1, bar2, bar3 ] } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/foo/-\", \"value\": \"bar4\" }")
        let resultingJson = JPSJsonPatch.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: " { \"foo\" : [ bar1, bar2, bar3, bar4 ] } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfPathElementsAreValid() {
        // "/a/b" works for:
        // { "a": { "foo": 1 } }
        // And is an error on:
        // { "q": { "bar": 2 } }
        XCTFail("Yet to be implemented.")
    }
    
}
