//
//  JPSAddOperationTests.swift
//  JsonPatchSwift
//
//  Created by Dominic Frei on 09/12/2015.
//  Copyright © 2015 Dominic Frei. All rights reserved.
//

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
