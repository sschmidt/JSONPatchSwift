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

// http://tools.ietf.org/html/rfc6902#section-4.4
// 4.  Operations
// 4.4.  move
class JPSMoveOperationTests: XCTestCase {
    
    // http://tools.ietf.org/html/rfc6902#appendix-A.6
    func testIfMoveValueInObjectReturnsExpectedValue() {
        let json = JSON(data: "{ \"foo\": { \"bar\": \"baz\", \"waldo\": \"fred\" }, \"qux\":{ \"corge\": \"grault\" } }".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"move\", \"path\": \"/qux/thud\", \"from\": \"/foo/waldo\" }")
        let resultingJson = JPSJsonPatch.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: " { \"foo\": { \"bar\": \"baz\" }, \"qux\": { \"corge\": \"grault\",\"thud\": \"fred\" } }".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    // http://tools.ietf.org/html/rfc6902#appendix-A.7
    func testIfMoveIndizesInArrayReturnsExpectedValue() {
        let json = JSON(data: " { \"foo\" : [\"all\", \"grass\", \"cows\", \"eat\"]} ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"move\", \"path\": \"/foo/3\", \"from\": \"/foo/1\" }")
        let resultingJson = JPSJsonPatch.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: "{ \"foo\" : [\"all\", \"cows\", \"eat\", \"grass\"]} ".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfObjectKeyMoveOperationReturnsExpectedValue() {
        let json = JSON(data: " { \"foo\" : { \"1\" : 2 }, \"bar\" : { }} ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"move\", \"path\": \"/bar/1\", \"from\": \"/foo/1\" }")
        let resultingJson = JPSJsonPatch.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: "{ \"foo\" : {  }, \"bar\" : { \"1\" : 2 }}".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfObjectKeyMoveToRootReplacesDocument() {
        let json = JSON(data: " { \"foo\" : { \"1\" : 2 }, \"bar\" : { }} ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"move\", \"path\": \"\", \"from\": \"/foo\" }")
        let resultingJson = JPSJsonPatch.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: "{ \"1\" : 2 }".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }

}
