//
//  JPSDocumentStructureTests.swift
//  JsonPatchSwift
//
//  Created by Dominic Frei on 07/12/2015.
//  Copyright © 2015 Dominic Frei. All rights reserved.
//

import XCTest
@testable import JsonPatchSwift

// http://tools.ietf.org/html/rfc6902#section-3
// 3. Document Structure

class JPSDocumentStructureTests: XCTestCase {

    func testIfJsonPatchIsValidJsonFormat() {
        XCTFail("Yet to be implemented.")
    }

    func testJsonPatchWithInvalidFormat() {
        XCTFail("Yet to be implemented.")
    }

    // Operations are identified by the key 'op'.
    func testIfJsonPatchContainsOnlyOneOperation() {
        XCTFail("Yet to be implemented.")
    }

    func testIfExamplesFromRFCAreRecognizedAsValidJsonPatches() {
        XCTFail("Yet to be implemented.")
        //        [
        //            { "op": "test", "path": "/a/b/c", "value": "foo" },
        //            { "op": "remove", "path": "/a/b/c" },
        //            { "op": "add", "path": "/a/b/c", "value": [ "foo", "bar" ] },
        //            { "op": "replace", "path": "/a/b/c", "value": 42 },
        //            { "op": "move", "from": "/a/b/c", "path": "/a/b/d" },
        //            { "op": "copy", "from": "/a/b/d", "path": "/a/b/e" }
        //        ]
    }

    func testIfOperationsAreAppliedInOrder() {
        // Changing the operation order MUST change the result.
        XCTFail("Yet to be implemented.")
    }

    func testIfInvalidOperationTriggersError() {
        XCTFail("Yet to be implemented.")
    }

}
