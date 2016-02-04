//===----------------------------------------------------------------------===//
//
// This source file is part of the JSONPatchSwift open source project.
//
// Copyright (c) 2015 EXXETA AG
// Licensed under Apache License v2.0
//
//
//===----------------------------------------------------------------------===//

import Foundation

import XCTest
@testable import JsonPatchSwift
import SwiftyJSON

// http://tools.ietf.org/html/rfc6902#section-4.6
// 4.  Operations
// 4.6. test
class JPSTestOperationTests: XCTestCase {
    
    func testIfBasicStringCheckReturnsExpectedResult() {
        let json = JSON(data: " { \"foo\" : { \"1\" : \"2\" }} ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"test\", \"path\": \"/foo/1\", \"value\": \"2\" }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        XCTAssertEqual(resultingJson, json)
    }

    func testIfInvalidBasicStringCheckReturnsExpectedResult() {
        let json = JSON(data: " { \"foo\" : { \"1\" : \"2\" }} ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"test\", \"path\": \"/foo/1\", \"value\": \"3\" }")
        do {
            let result = try JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
            XCTFail(result.rawString()!)
        } catch JPSJsonPatcher.JPSJsonPatcherApplyError.ValidationError(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
        } catch {
            XCTFail("Unexpected error.")
        }
    }

    func testIfBasicIntCheckReturnsExpectedResult() {
        let json = JSON(data: " { \"foo\" : { \"1\" : 2 }} ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"test\", \"path\": \"/foo/1\", \"value\": 2 }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        XCTAssertEqual(resultingJson, json)
    }

    func testIfInvalidBasicIntCheckReturnsExpectedResult() {
        let json = JSON(data: " { \"foo\" : { \"1\" : 2 }} ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"test\", \"path\": \"/foo/1\", \"value\": 3 }")
        do {
            let result = try JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
            XCTFail(result.rawString()!)
        } catch JPSJsonPatcher.JPSJsonPatcherApplyError.ValidationError(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
        } catch {
            XCTFail("Unexpected error.")
        }
    }

    func testIfBasicObjectCheckReturnsExpectedResult() {
        let json = JSON(data: " { \"foo\" : { \"1\" : 2 }} ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"test\", \"path\": \"/foo\", \"value\": { \"1\" : 2 } }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        XCTAssertEqual(resultingJson, json)
    }

    func testIfInvalidBasicObjectCheckReturnsExpectedResult() {
        let json = JSON(data: " { \"foo\" : { \"1\" : \"2\" }} ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"test\", \"path\": \"/foo\", \"value\": { \"1\" : 3 } }")
        do {
            let result = try JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
            XCTFail(result.rawString()!)
        } catch JPSJsonPatcher.JPSJsonPatcherApplyError.ValidationError(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
        } catch {
            XCTFail("Unexpected error.")
        }
    }

    func testIfBasicArrayCheckReturnsExpectedResult() {
        let json = JSON(data: " { \"foo\" : [1, 2, 3, 4, 5]} ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"test\", \"path\": \"/foo\", \"value\": [1, 2, 3, 4, 5] }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        XCTAssertEqual(resultingJson, json)
    }

    func testIfInvalidBasicArrayCheckReturnsExpectedResult() {
        let json = JSON(data: " { \"foo\" : [1, 2, 3, 4, 5]} ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"test\", \"path\": \"/foo\", \"value\": [1, 2, 3, 4, 5, 6, 7, 42] }")
        do {
            let result = try JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
            XCTFail(result.rawString()!)
        } catch JPSJsonPatcher.JPSJsonPatcherApplyError.ValidationError(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
        } catch {
            XCTFail("Unexpected error.")
        }
    }
}
