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
        let json = JSON(data: " [ \"foo\", 42, \"bar\" ] ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/2\", \"value\": \"42\" }")
        let resultingJson = JPSJsonPatch.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: " [ \"foo\", 42, \"42\", \"bar\" ] ".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfPathToNonExistingMemberCreatesNewMember1() {
        let json = JSON(data: " { \"foo\" : \"bar\" } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/bar\", \"value\": \"foo\" }")
        let resultingJson = JPSJsonPatch.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: "{ \"foo\" : \"bar\", \"bar\" : \"foo\" }".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfPathToNonExistingMemberCreatesNewMember2() {
        let json = JSON(data: " { \"foo\" : \" { \"foo2\" : \"bar\" } \" } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/foo/bar\", \"value\": \"foo\" }")
        let resultingJson = JPSJsonPatch.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: " { \"foo\" : \" { \"foo2\" : \"bar\", \"bar\" : \"foo\" } \" } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfPathToNonExistingMemberCreatesNewMember3() {
        let json = JSON(data: " { \"foo\" : \" [ { \"foo\" : \"bar\" }, { \"blaa\" : \" { \" blubb \" : \"bloobb\" } \" } ] \" } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/foo/01/blaa/blubby\", \"value\": \"foo\" }")
        let resultingJson = JPSJsonPatch.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: " { \"foo\" : \" [ { \"foo\" : \"bar\" }, { \"blaa\" : \" { \" blubb \" : \"bloobb\", \"blubby\" : \"foo\" } \" } ] \" } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfPathToExistingMemberReplacesIt1() {
        let json = JSON(data: " { \"foo\" : \"bar\" } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/foo\", \"value\": \"foobar\" }")
        let resultingJson = JPSJsonPatch.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: "{ \"foo\" : \"foobar\" }".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfPathToExistingMemberReplacesIt2() {
        let json = JSON(data: " { \"foo\" : \" [ { \"foo\" : \"bar\" }, { \"blaa\" : \" { \" blubb \" : \"bloobb\" } \" } ] \" } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/foo/1/blaa/ blubb \", \"value\": \"foo\" }")
        let resultingJson = JPSJsonPatch.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: " { \"foo\" : \" [ { \"foo\" : \"bar\" }, { \"blaa\" : \" { \" blubb \" : \"foo\" } \" } ] \" } ".dataUsingEncoding(NSUTF8StringEncoding)!)
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
    
    func testIfPathElementIsValid() {
        let json = JSON(data: " { \"a\": { \"foo\": 1 } } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/a/b\", \"value\": \"bar\" }")
        let resultingJson = JPSJsonPatch.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: " { \"a\": { \"foo\": 1, \"b\" : \"bar\" } } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfInvalidPathElementRaisesError() {
        do {
            let _ = try JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/a/b\", \"value\": \"bar\" }")
            XCTFail("Unreachable code. Should have raised an error, because 'a' must exist to access 'b'.")
        } catch (let message) {
            XCTAssertNotNil(message)
        }
    }
    
}
