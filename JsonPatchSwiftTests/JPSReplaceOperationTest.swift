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

// http://tools.ietf.org/html/rfc6902#section-4.3
// 4.  Operations
// 4.3. replace
class JPSReplaceOperationTests: XCTestCase {
    
    // http://tools.ietf.org/html/rfc6902#appendix-A.5
    func testIfReplaceValueInObjectReturnsExpectedValue() {
        let json = JSON(data: "{\"baz\": \"qux\",\"foo\": \"bar\"}".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"replace\", \"path\": \"/baz\", \"value\": \"boo\" }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: "  { \"baz\": \"boo\",\"foo\": \"bar\" } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfReplaceValueInArrayArrayReturnsExpectedValue() {
        let json = JSON(data: " { \"foo\" : [1, 2, 3, 4], \"bar\" : []} ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"replace\", \"path\": \"/foo/1\", \"value\": 42 }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: " { \"foo\" : [1, 42, 3, 4], \"bar\" : []}".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfMissingValueRaisesError() {
        do {
            let result = try JPSJsonPatch("{ \"op\": \"replace\", \"path\": \"/foo/1\" }") // value missing
            XCTFail(result.operations.last!.value.rawString()!)
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.InvalidPatchFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
        } catch {
            XCTFail("Unexpected error.")
        }

    }
}
