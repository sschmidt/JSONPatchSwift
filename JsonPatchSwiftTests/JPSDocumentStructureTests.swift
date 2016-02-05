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

// swiftlint:disable opening_brace
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
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" }")
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0 = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.Test)
    }
    
    func testJsonPatchWithDictionaryAsRootElementForOperationAdd() {
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/a/b/c\", \"value\": \"foo\" }")
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0 = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.Add)
    }
    
    func testJsonPatchWithDictionaryAsRootElementForOperationCopy() {
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"copy\", \"path\": \"/a/b/c\", \"from\": \"/foo\" }")
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0 = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.Copy)
    }
    
    func testJsonPatchWithDictionaryAsRootElementForOperationRemove() {
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"remove\", \"path\": \"/a/b/c\" }")
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0 = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.Remove)
    }
    
    func testJsonPatchWithDictionaryAsRootElementForOperationReplace() {
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"replace\", \"path\": \"/a/b/c\", \"value\": \"foo\" }")
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0 = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.Replace)
    }
    
    func testJsonPatchRejectsMissingOperation() {
        do {
            let _ = try JPSJsonPatch("{ \"path\": \"/a/b/c\", \"value\": \"foo\" }")
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.InvalidPatchFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, JPSConstants.JsonPatch.InitialisationErrorMessages.OpElementNotFound)
        } catch {
            XCTFail("Unexpected error.")
        }
    }
    
    func testJsonPatchRejectsMissingPath() {
        do {
            let _ = try JPSJsonPatch("{ \"op\": \"add\", \"value\": \"foo\" }")
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.InvalidPatchFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, JPSConstants.JsonPatch.InitialisationErrorMessages.PathElementNotFound)
        } catch {
            XCTFail("Unexpected error.")
        }
    }
    
    func testJsonPatchSavesValue() {
        let jsonPatch = try! JPSJsonPatch("[{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" }]")
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        XCTAssertEqual(jsonPatch.operations[0].value.string, "foo")
    }
    
    func testJsonPatchRejectsMissingValue() {
        do {
            let _ = try JPSJsonPatch("{ \"op\": \"add\", \"path\": \"foo\" }")
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.InvalidPatchFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, "Could not find 'value' element.")
        } catch {
            XCTFail("Unexpected error.")
        }
    }
    
    func testJsonPatchRejectsEmptyArray() {
        do {
            let _ = try JPSJsonPatch("[]")
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
        let patch = "["
            + "{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" },"
            + "{ \"op\": \"remove\", \"path\": \"/a/b/c\" },"
            + "{ \"op\": \"add\", \"path\": \"/a/b/c\", \"value\": [ \"foo\", \"bar\" ] },"
            + "{ \"op\": \"replace\", \"path\": \"/a/b/c\", \"value\": 42 },"
            + "{ \"op\": \"move\", \"from\": \"/a/b/c\", \"path\": \"/a/b/d\" },"
            + "{ \"op\": \"copy\", \"from\": \"/a/b/d\", \"path\": \"/a/b/e\" }"
            + "]"
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
            let _ = try JPSJsonPatch("{op:foo}")
            XCTFail("Unreachable code. Should have raised an error.")
        } catch {
            // Expected behaviour.
        }
    }
    
    func testInvalidOperationsAreRejected() {
        do {
            let _ = try JPSJsonPatch("{\"op\" : \"foo\", \"path\" : \"/a/b\"}")
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.InvalidPatchFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, "Operation is invalid.")
        } catch {
            XCTFail("Unexpected error.")
        }
    }
    
    // JSON Pointer: RFC6901
    // Multiple tests necessary here
    func testIfPathContainsValidJsonPointer() {
        do {
            let _ = try JPSJsonPatch("{\"op\" : \"add\", \"path\" : \"foo\" , \"value\" : \"foo\"}")
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPointerError.ValueDoesNotContainDelimiter {
            // Expected behaviour.
        } catch {
            XCTFail("Unexpected error.")
        }
    }
    
    func testIfAdditionalElementsAreIgnored() {
        let patch = "{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\", \"additionalParamter\": \"foo\" }"
        let jsonPatch = try! JPSJsonPatch(patch)
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0 = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.Test)
    }
    
    func testIfElementsNotNecessaryForOperationAreIgnored() {
        let patch = "{ \"op\": \"remove\", \"path\": \"/a/b/c\", \"value\": \"foo\", \"additionalParamter\": \"foo\" }"
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
        let patch0 = "{ \"op\": \"add\", \"path\": \"/a/b/c\", \"value\": \"foo\" }"
        let jsonPatch0 = try! JPSJsonPatch(patch0)
        XCTAssertNotNil(jsonPatch0)
        XCTAssertNotNil(jsonPatch0.operations)
        XCTAssertEqual(jsonPatch0.operations.count, 1)
        XCTAssertTrue((jsonPatch0.operations[0] as Any) is JPSOperation)
        let operation0 = jsonPatch0.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.Add)
        
        let patch1 = "{ \"path\": \"/a/b/c\", \"op\": \"add\", \"value\": \"foo\" }"
        let jsonPatch1 = try! JPSJsonPatch(patch1)
        XCTAssertNotNil(jsonPatch1)
        XCTAssertNotNil(jsonPatch1.operations)
        XCTAssertEqual(jsonPatch1.operations.count, 1)
        XCTAssertTrue((jsonPatch1.operations[0] as Any) is JPSOperation)
        let operation1 = jsonPatch1.operations[0]
        XCTAssertEqual(operation1.type, JPSOperation.JPSOperationType.Add)
        
        let patch2 = "{ \"value\": \"foo\", \"path\": \"/a/b/c\", \"op\": \"add\" }"
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
        let patch0 = "{ \"op\": \"add\", \"path\": \"/a/b/c\", \"value\": \"foo\" }"
        let patch1 = "["
            + "{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" },"
            + "{ \"op\": \"add\", \"path\": \"/a/b/c\", \"value\": \"foo\" },"
            + "]"
        let jsonPatch0 = try! JPSJsonPatch(patch0)
        let jsonPatch1 = try! JPSJsonPatch(patch1)
        XCTAssertFalse(jsonPatch0 == jsonPatch1)
    }
    
    func testEqualityOperatorWithDifferentOperations() {
        let patch0 = "{ \"op\": \"add\", \"path\": \"/a/b/c\", \"value\": \"foo\" }"
        let patch1 = "{ \"op\": \"remove\", \"path\": \"/a/b/c\" }"
        let jsonPatch0 = try! JPSJsonPatch(patch0)
        let jsonPatch1 = try! JPSJsonPatch(patch1)
        XCTAssertFalse(jsonPatch0 == jsonPatch1)
    }
    
    func testIfApplyingPatchToInvalidJsonResultsInError() {
        XCTFail("Yet to be implemented.")
    }
    
}
