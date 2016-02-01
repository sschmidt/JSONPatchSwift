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
        let patch = try! JPSJsonPatch("{ \"op\" : \"add\", \"path\" : \"/a\", \"value\" : \"foo\" }")
        let json = JSON(data: "{\"b\" : \"bar\"}".dataUsingEncoding(NSUTF8StringEncoding)!)
        let resultingJson = JPSJsonPatch.applyPatch(patch, toJson: json)
        let expectedJson = JSON(data: "{ \"a\" : \"foo\", \"b\" : \"bar\" }".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfPathToExistingMemberReplacesIt() {
        let json = JSON(data: " { \"foo\" : \"bar\" } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/a/b/c\", \"value\": \"foo\" }")
        XCTFail("Yet to be implemented.")
    }
    
    func testIfPathToRootReplacesWholeDocument() {
        let json = JSON(data: " { \"foo\" : \"bar\" } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"\", \"value\": { \"bar\" : \"foo\" } }")
        let resultingJson = JPSJsonPatch.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: "{ \"bar\" : \"foo\" }".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfInsertingToAnArrayWithAndIndexTooBigResultsInAnError() {
        XCTFail("Yet to be implemented.")
    }
    
    func testIfMinusAtEndOfPathAppendsToArray() {
        // path: /a/b/-
        XCTFail("Yet to be implemented.")
    }
    
    func testIfPathElementsAreValid() {
        // "/a/b" works for:
        // { "a": { "foo": 1 } }
        // And is an error on:
        // { "q": { "bar": 2 } }
        XCTFail("Yet to be implemented.")
    }
    
}
