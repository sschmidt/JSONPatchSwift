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
    
    func testJsonPatchContainsArrayOfOperations() {
        let jsonPatch = try! JPSJsonPatch("[{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" }]")
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
    }
    
    func testJsonPatchReadsAllOperations() {
        let jsonPatch = try! JPSJsonPatch("[{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" }, { \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" }, { \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" }]")
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 3)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        XCTAssertTrue((jsonPatch.operations[1] as Any) is JPSOperation)
        XCTAssertTrue((jsonPatch.operations[2] as Any) is JPSOperation)
    }
    
    func testJsonPatchOperationsHaveSameOrderAsInJsonRepresentation() {
        let jsonPatch = try! JPSJsonPatch("[{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" }, { \"op\": \"add\", \"path\": \"/a/b/c\", \"value\": \"foo\" }, { \"op\": \"remove\", \"path\": \"/a/b/c\", \"value\": \"foo\" }]")
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 3)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0 = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperationType.Test)
        XCTAssertTrue((jsonPatch.operations[1] as Any) is JPSOperation)
        let operation1 = jsonPatch.operations[0]
        XCTAssertEqual(operation1.type, JPSOperationType.Add)
        XCTAssertTrue((jsonPatch.operations[2] as Any) is JPSOperation)
        let operation2 = jsonPatch.operations[0]
        XCTAssertEqual(operation2.type, JPSOperationType.Remove)
    }
    
    // This is about the JSON format in general.
    func testJsonPatchRejectsInvalidJsonFormat() {
//        do {
//            _ = try JPSJsonPatch("!#€%&/()*^*_:;;:;_poawolwasnndaw")
//            XCTFail("Unreachable code. Should have raised an error.")
//        } catch let error = JPSJsonPatchInitialisationError.InvalidJsonFormat {
//            error.me
//            // Expected behaviour.
//        } catch {
//            XCTFail("Unreachable code. Should have raised another error.")
//        }
    }
    
    func testJsonPatchRejectsMissingOperation() {
        XCTFail("Yet to be implemented.")
    }
    
    func testJsonPatchRejectsMissingPath() {
        XCTFail("Yet to be implemented.")
    }
    
    func testJsonPatchRejectsMissingValue() {
        XCTFail("Yet to be implemented.")
    }
    
    // Examples from the RFC itself.
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
    
}
