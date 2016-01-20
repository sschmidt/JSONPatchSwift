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
            // NSJSONSerialisation just ignores the second 'op' instead of raising an error.
            // Further investigation needed on how to solve that, except for manually parsing the string ...
//            XCTFail("Unreachable code. Should have raised an error.")
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
            // NSJSONSerialisation just ignores the second 'op' instead of raising an error.
            // Further investigation needed on how to solve that, except for manually parsing the string ...
//            XCTFail("Unreachable code. Should have raised an error.")
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
            let _ = try JPSJsonPatch("{\"op\" : \"add\", \"path\" : \"foo\" }")
            // swiftlint:enable opening_brace
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPointerError.ValueDoesNotContainDelimiter {
            // Expected behaviour.
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
    
    func testIfElementsNotNecessaryForOperationAreIgnored() {
        // swiftlint:disable opening_brace
        let patch = "{ \"op\": \"remove\", \"path\": \"/a/b/c\", \"value\": \"foo\", \"additionalParamter\": \"foo\" }"
        // swiftlint:enable opening_brace
        let jsonPatch = try! JPSJsonPatch(patch)
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0 = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.Remove)
    }
    
    func testIfReorderedMembersOfOneOperationLeadToSameResult() {
        // Examples from RFC:
        // swiftlint:disable opening_brace
        let patch0 = "{ \"op\": \"add\", \"path\": \"/a/b/c\", \"value\": \"foo\" }"
        // swiftlint:enable opening_brace
        let jsonPatch0 = try! JPSJsonPatch(patch0)
        XCTAssertNotNil(jsonPatch0)
        XCTAssertNotNil(jsonPatch0.operations)
        XCTAssertEqual(jsonPatch0.operations.count, 1)
        XCTAssertTrue((jsonPatch0.operations[0] as Any) is JPSOperation)
        let operation0 = jsonPatch0.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.Add)
        
        // swiftlint:disable opening_brace
        let patch1 = "{ \"path\": \"/a/b/c\", \"op\": \"add\", \"value\": \"foo\" }"
        // swiftlint:enable opening_brace
        let jsonPatch1 = try! JPSJsonPatch(patch1)
        XCTAssertNotNil(jsonPatch1)
        XCTAssertNotNil(jsonPatch1.operations)
        XCTAssertEqual(jsonPatch1.operations.count, 1)
        XCTAssertTrue((jsonPatch1.operations[0] as Any) is JPSOperation)
        let operation1 = jsonPatch1.operations[0]
        XCTAssertEqual(operation1.type, JPSOperation.JPSOperationType.Add)
        
        // swiftlint:disable opening_brace
        let patch2 = "{ \"value\": \"foo\", \"path\": \"/a/b/c\", \"op\": \"add\" }"
        // swiftlint:enable opening_brace
        let jsonPatch2 = try! JPSJsonPatch(patch2)
        XCTAssertNotNil(jsonPatch2)
        XCTAssertNotNil(jsonPatch2.operations)
        XCTAssertEqual(jsonPatch2.operations.count, 1)
        XCTAssertTrue((jsonPatch2.operations[0] as Any) is JPSOperation)
        let operation2 = jsonPatch2.operations[0]
        XCTAssertEqual(operation2.type, JPSOperation.JPSOperationType.Add)
        
        XCTAssertTrue(jsonPatch0 == jsonPatch1)
        XCTAssertTrue(jsonPatch0 == jsonPatch2)
        XCTAssertTrue(jsonPatch1 == jsonPatch2)
        XCTAssertTrue(operation0 == operation1)
        XCTAssertTrue(operation0 == operation2)
        XCTAssertTrue(operation1 == operation2)
    }
    
    func testEqualityOperatorWithDifferentAmountsOfOperations() {
        // swiftlint:disable opening_brace
        let patch0 = "{ \"op\": \"add\", \"path\": \"/a/b/c\" }"
        let patch1 = "["
            + "{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" },"
            + "{ \"op\": \"remove\", \"path\": \"/a/b/c\" },"
            + "]"
        // swiftlint:enable opening_brace
        let jsonPatch0 = try! JPSJsonPatch(patch0)
        let jsonPatch1 = try! JPSJsonPatch(patch1)
        XCTAssertFalse(jsonPatch0 == jsonPatch1)
    }
    
    func testEqualityOperatorWithDifferentOperations() {
        // swiftlint:disable opening_brace
        let patch0 = "{ \"op\": \"add\", \"path\": \"/a/b/c\" }"
        let patch1 = "{ \"op\": \"remove\", \"path\": \"/a/b/c\" }"
        // swiftlint:enable opening_brace
        let jsonPatch0 = try! JPSJsonPatch(patch0)
        let jsonPatch1 = try! JPSJsonPatch(patch1)
        XCTAssertFalse(jsonPatch0 == jsonPatch1)
    }
    
    func testIfApplyingPatchToInvalidJsonResultsInError() {
        XCTFail("Yet to be implemented.")
    }
    
}
