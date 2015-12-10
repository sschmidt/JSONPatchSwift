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
// 3. Document Structure (and the general Part of Chapter 4)

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
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.Test)
        XCTAssertTrue((jsonPatch.operations[1] as Any) is JPSOperation)
        let operation1 = jsonPatch.operations[1]
        XCTAssertEqual(operation1.type, JPSOperation.JPSOperationType.Add)
        XCTAssertTrue((jsonPatch.operations[2] as Any) is JPSOperation)
        let operation2 = jsonPatch.operations[2]
        XCTAssertEqual(operation2.type, JPSOperation.JPSOperationType.Remove)
    }
    
    // This is about the JSON format in general.
    func testJsonPatchRejectsInvalidJsonFormat() {
        do {
            _ = try JPSJsonPatch("!#€%&/()*^*_:;;:;_poawolwasnndaw")
            XCTFail("Unreachable code. Should have raised an error.")
        } catch {
            // Expected behaviour.
        }
    }
    
    func testJsonPatchWithDictionaryAsRootElementForOperationTest() {
        // swiftlint:disable opening_brace
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" }")
        // swiftlint:enable opening_brace
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0 = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.Test)
    }
    
    func testJsonPatchWithDictionaryAsRootElementForOperationAdd() {
        // swiftlint:disable opening_brace
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/a/b/c\", \"value\": \"foo\" }")
        // swiftlint:enable opening_brace
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0 = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.Add)
    }
    
    func testJsonPatchWithDictionaryAsRootElementForOperationCopy() {
        // swiftlint:disable opening_brace
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"copy\", \"path\": \"/a/b/c\", \"value\": \"foo\" }")
        // swiftlint:enable opening_brace
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0 = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.Copy)
    }
    
    func testJsonPatchWithDictionaryAsRootElementForOperationRemove() {
        // swiftlint:disable opening_brace
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"remove\", \"path\": \"/a/b/c\", \"value\": \"foo\" }")
        // swiftlint:enable opening_brace
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0 = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.Remove)
    }
    
    func testJsonPatchWithDictionaryAsRootElementForOperationReplace() {
        // swiftlint:disable opening_brace
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"replace\", \"path\": \"/a/b/c\", \"value\": \"foo\" }")
        // swiftlint:enable opening_brace
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0 = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.Replace)
    }
    
    func testJsonPatchRejectsMissingOperation() {
        do {
            // swiftlint:disable opening_brace
            let _ = try JPSJsonPatch("{ \"path\": \"/a/b/c\", \"value\": \"foo\" }")
            // swiftlint:enable opening_brace
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.InvalidPatchFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, "Could not find 'op' element.")
        } catch {
            XCTFail("Unexpected error.")
        }
    }
    
    func testJsonPatchRejectsMissingPath() {
        do {
            // swiftlint:disable opening_brace
            let _ = try JPSJsonPatch("{ \"op\": \"add\", \"value\": \"foo\" }")
            // swiftlint:enable opening_brace
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.InvalidPatchFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, "Could not find 'path' element.")
        } catch {
            XCTFail("Unexpected error.")
        }
    }
    
    func testJsonPatchRejectsEmptyArray() {
        do {
            // swiftlint:disable opening_brace
            let _ = try JPSJsonPatch("[]")
            // swiftlint:enable opening_brace
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.InvalidPatchFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, "Patch array does not contain elements.")
        } catch {
            XCTFail("Unexpected error.")
        }
    }
    
    // Examples from the RFC itself.
    func testIfExamplesFromRFCAreRecognizedAsValidJsonPatches() {
        // swiftlint:disable opening_brace
        let patch = "["
            + "{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" },"
            + "{ \"op\": \"remove\", \"path\": \"/a/b/c\" },"
            + "{ \"op\": \"add\", \"path\": \"/a/b/c\", \"value\": [ \"foo\", \"bar\" ] },"
            + "{ \"op\": \"replace\", \"path\": \"/a/b/c\", \"value\": 42 },"
            + "{ \"op\": \"move\", \"from\": \"/a/b/c\", \"path\": \"/a/b/d\" },"
            + "{ \"op\": \"copy\", \"from\": \"/a/b/d\", \"path\": \"/a/b/e\" }"
            + "]"
        // swiftlint:enable opening_brace
        let jsonPatch = try! JPSJsonPatch(patch)
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 6)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0 = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.Test)
        XCTAssertTrue((jsonPatch.operations[1] as Any) is JPSOperation)
        let operation1 = jsonPatch.operations[1]
        XCTAssertEqual(operation1.type, JPSOperation.JPSOperationType.Remove)
        XCTAssertTrue((jsonPatch.operations[2] as Any) is JPSOperation)
        let operation2 = jsonPatch.operations[2]
        XCTAssertEqual(operation2.type, JPSOperation.JPSOperationType.Add)
        XCTAssertTrue((jsonPatch.operations[3] as Any) is JPSOperation)
        let operation3 = jsonPatch.operations[3]
        XCTAssertEqual(operation3.type, JPSOperation.JPSOperationType.Replace)
        XCTAssertTrue((jsonPatch.operations[4] as Any) is JPSOperation)
        let operation4 = jsonPatch.operations[4]
        XCTAssertEqual(operation4.type, JPSOperation.JPSOperationType.Move)
        XCTAssertTrue((jsonPatch.operations[5] as Any) is JPSOperation)
        let operation5 = jsonPatch.operations[5]
        XCTAssertEqual(operation5.type, JPSOperation.JPSOperationType.Copy)
    }
    
    func testInvalidJsonGetsRejected() {
        do {
            // swiftlint:disable opening_brace
            let _ = try JPSJsonPatch("{op:foo}")
            // swiftlint:enable opening_brace
            XCTFail("Unreachable code. Should have raised an error.")
        } catch {
            // Expected behaviour.
        }
    }
    
    func testInvalidOperationsAreRejected() {
        do {
            // swiftlint:disable opening_brace
            let _ = try JPSJsonPatch("{\"op\" : \"foo\", \"path\" : \"/a/b\"}")
            // swiftlint:enable opening_brace
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.InvalidPatchFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, "Operation 'foo' is invalid.")
        } catch {
            XCTFail("Unexpected error.")
        }
    }
    
    func testMultipleOpElementsAreRejected() {
        do {
            // swiftlint:disable opening_brace
            let _ = try JPSJsonPatch("{\"op\" : \"add\", \"path\" : \"/a/b\", \"op\" : \"remove\"}")
            // swiftlint:enable opening_brace
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.InvalidPatchFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, "There can be only one 'op' element.")
        } catch {
            XCTFail("Unexpected error.")
        }
    }
    
    func testExactlyOnePathMemeber() {
        do {
            // swiftlint:disable opening_brace
            let _ = try JPSJsonPatch("{\"op\" : \"add\", \"path\" : \"/a/b\", \"path\" : \"/a/b\"}")
            // swiftlint:enable opening_brace
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.InvalidPatchFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, "There can be only one 'path' element.")
        } catch {
            XCTFail("Unexpected error.")
        }
    }
    
    // JSON Pointer: RFC6901
    // Multiple tests necessary here
    func testIfPathContainsValidJsonPointer() {
        do {
            // swiftlint:disable opening_brace
            let _ = try JPSJsonPatch("{\"op\" : \"add\", \"path\" : \"/a/b\", \"path\" : \"/a/b\"}")
            // swiftlint:enable opening_brace
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.InvalidPatchFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, "Value of 'path' is not a valid JSON Pointer.")
        } catch {
            XCTFail("Unexpected error.")
        }
    }
    
    func testIfAdditionalElementsAreIgnored() {
        // swiftlint:disable opening_brace
        let patch = "{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\", \"additionalParamter\": \"foo\" }"
        // swiftlint:enable opening_brace
        let jsonPatch = try! JPSJsonPatch(patch)
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0 = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.Test)
    }
    
}
