//===----------------------------------------------------------------------===//
//
// This source file is part of the JSONPatchSwift open source project.
//
// Copyright (c) 2015 EXXEETA AG
// Licensed under Apache License v2.0
//
//
//===----------------------------------------------------------------------===//

import XCTest
@testable import JsonPatchSwift

// http://tools.ietf.org/html/rfc6902#section-4.1
// 4.  Operations
// 4.1.  add

class JPSAddOperationTests: XCTestCase {
    
    func testIfPathToArrayInsertsValueAtPositionAndShiftsRemainingMembersRight() {
        XCTFail("Yet to be implemented.")
    }

    func testIfPathToNonExistingMemberCreatesNewMember() {
        let patch = JPSJsonPatch("{ \"op\" : \"add\", \"path\" : \"\", \"\" : \"\" }")
        XCTFail("Yet to be implemented.")
    }
    
    func testIfPathToExistingMemberReplacesIt() {
        XCTFail("Yet to be implemented.")
    }
    
    func testIfPathToRootReplacesWholeDocument() {
        XCTFail("Yet to be implemented.")
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
