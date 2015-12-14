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
        let operation1 = jsonPatch.operations[1]
        XCTAssertEqual(operation1.type, JPSOperationType.Add)
        XCTAssertTrue((jsonPatch.operations[2] as Any) is JPSOperation)
        let operation2 = jsonPatch.operations[2]
        XCTAssertEqual(operation2.type, JPSOperationType.Remove)
    }
    
    // This is about the JSON format in general.
    func testJsonPatchRejectsInvalidJsonFormat() {
        do {
            _ = try JPSJsonPatch("!#€%&/()*^*_:;;:;_poawolwasnndaw")
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPatchInitialisationError.InvalidJsonFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, "JSON transformation failed.")
        } catch {
            XCTFail("Unreachable code. Should have raised another error.")
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
        XCTAssertEqual(operation0.type, JPSOperationType.Test)
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
        XCTAssertEqual(operation0.type, JPSOperationType.Add)
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
        XCTAssertEqual(operation0.type, JPSOperationType.Copy)
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
        XCTAssertEqual(operation0.type, JPSOperationType.Remove)
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
        XCTAssertEqual(operation0.type, JPSOperationType.Replace)
    }
    
    func testJsonPatchRejectsMissingOperation() {
        do {
            // swiftlint:disable opening_brace
            let _ = try JPSJsonPatch("{ \"path\": \"/a/b/c\", \"value\": \"foo\" }")
            // swiftlint:enable opening_brace
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPatchInitialisationError.InvalidPatchFormat(let message) {
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
        } catch JPSJsonPatchInitialisationError.InvalidPatchFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, "Could not find 'op' element.")
        } catch {
            XCTFail("Unexpected error.")
        }
    }
    
    func testJsonPatchRejectsMissingValue() {
        do {
            // swiftlint:disable opening_brace
            let _ = try JPSJsonPatch("{ \"path\": \"/a/b/c\", \"op\": \"add\" }")
            // swiftlint:enable opening_brace
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPatchInitialisationError.InvalidPatchFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, "Could not find 'op' element.")
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
        XCTAssertEqual(operation0.type, JPSOperationType.Test)
        XCTAssertTrue((jsonPatch.operations[1] as Any) is JPSOperation)
        let operation1 = jsonPatch.operations[1]
        XCTAssertEqual(operation1.type, JPSOperationType.Remove)
        XCTAssertTrue((jsonPatch.operations[2] as Any) is JPSOperation)
        let operation2 = jsonPatch.operations[2]
        XCTAssertEqual(operation2.type, JPSOperationType.Add)
        XCTAssertTrue((jsonPatch.operations[3] as Any) is JPSOperation)
        let operation3 = jsonPatch.operations[3]
        XCTAssertEqual(operation3.type, JPSOperationType.Replace)
        XCTAssertTrue((jsonPatch.operations[4] as Any) is JPSOperation)
        let operation4 = jsonPatch.operations[4]
        XCTAssertEqual(operation4.type, JPSOperationType.Move)
        XCTAssertTrue((jsonPatch.operations[5] as Any) is JPSOperation)
        let operation5 = jsonPatch.operations[5]
        XCTAssertEqual(operation5.type, JPSOperationType.Copy)
    }
    
}
