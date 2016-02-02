//===----------------------------------------------------------------------===//
//
// This source file is part of the JSONPatchSwift open source project.
//
// Copyright (c) 2015 EXXETA AG
// Licensed under Apache License v2.0
//
//
//===----------------------------------------------------------------------===//

import SwiftyJSON
import XCTest
@testable import JsonPatchSwift

// JavaScript Object Notation (JSON) Pointer
// https://tools.ietf.org/html/rfc6901

class JPSJsonPointerTests: XCTestCase {}


// MARK: - chapter 3 tests

extension JPSJsonPointerTests {

    func testIfEmptyPointerIsValid() {
        let jsonPointer = try! JPSJsonPointer(rawValue: "")
        XCTAssertEqual(jsonPointer.rawValue, "")
    }
    
    func testIfJsonPointerIsAString() {
        let jsonPointer = try! JPSJsonPointer(rawValue: "/a/b")
        XCTAssertEqual(jsonPointer.rawValue, "/a/b")
    }
    
    func testIfJsoinPointerRejectsInputWithoutSlashDelimiter() {
        do {
            let _ = try JPSJsonPointer(rawValue: "ab")
            XCTFail("Unreachable code. Invalid pointer should raise an error.")
        } catch {
            // Expected behaviour.
        }
    }
    
    func testIfNonEmptyJsonPointerStartsWithDelimiter() {
        do {
            let _ = try JPSJsonPointer(rawValue: "a/b/c")
            XCTFail("Unreachable code. Invalid pointer should raise an error.")
        } catch {
            // Expected behaviour.
        }
    }
    
    func testIfEmptyReferenceTokenIsInvalid() {
        do {
            let _ = try JPSJsonPointer(rawValue: "/a//c")
            XCTFail("Unreachable code. Invalid pointer should raise an error.")
        } catch {
            // Expected behaviour.
        }
    }
    
    func testIfPointerOnlyContainingDelimiterIsInvalid() {
        do {
            let _ = try JPSJsonPointer(rawValue: JPSConstants.JsonPointer.Delimiter)
            XCTFail("Unreachable code. Invalid pointer should raise an error.")
        } catch {
            // Expected behaviour.
        }
    }
    
    func testForSeveralUnicodeCharacters() {
        let rawValue = "/1234567890-=!@£$%^&*()_+¡€#¢∞§¶•ªº–≠⁄™‹›ﬁﬂ‡°·‚—±qwertyuiop[]QWERTYUIOP{}œ∑´®†¥¨^øπ“‘Œ„‰ÂÊÁËÈØ∏’asdfghjkl;'ASDFGHJKL:|åß∂ƒ©˙∆˚¬…æ«ÅÍÎÏÌÓÔÒÚÆ»`zxcvbnm,./~ZXCVBNM<>?`Ω≈ç√∫~µ≤≥÷ŸÛÙÇ◊ıˆ˜¯˘¿"
        let jsonPointer = try! JPSJsonPointer(rawValue: rawValue)
        XCTAssertEqual(jsonPointer.rawValue, rawValue)
    }
    
//    The ABNF syntax of a JSON Pointer is:
//    
//    json-pointer    = *( JPSConstants.JsonPointer.Delimiter reference-token )
//    reference-token = *( unescaped / escaped )
//    unescaped       = %x00-2E / %x30-7D / %x7F-10FFFF
//    ; %x2F ('/') and %x7E ('~') are excluded from 'unescaped'
//    escaped         = JPSConstants.JsonPointer.EscapeCharater ( "0" / "1" )
//    ; representing '~' and '/', respectively
//    
//    It is an error condition if a JSON Pointer value does not conform to
//    this syntax (see Section 7).
//    
//    Note that JSON Pointers are specified in characters, not as bytes.
    
    
}


// MARK: - chapter 4 tests

extension JPSJsonPointerTests {
    
    func testIfTildeEscapedCharactersAreDecoded() {
        let jsonPointer1 = try! JPSJsonPointer(rawValue: "/~1")
        XCTAssertEqual(jsonPointer1.pointerValue.count, 1)
        XCTAssertEqual(jsonPointer1.pointerValue[0] as? String, JPSConstants.JsonPointer.Delimiter)
        let jsonPointer2 = try! JPSJsonPointer(rawValue: "/~0")
        XCTAssertEqual(jsonPointer2.pointerValue.count, 1)
        XCTAssertEqual(jsonPointer2.pointerValue[0] as? String, JPSConstants.JsonPointer.EscapeCharater)
        let jsonPointer3 = try! JPSJsonPointer(rawValue: "/~01")
        XCTAssertEqual(jsonPointer3.pointerValue.count, 1)
        XCTAssertEqual(jsonPointer3.pointerValue[0] as? String, JPSConstants.JsonPointer.EscapedDelimiter)
        let jsonPointer4 = try! JPSJsonPointer(rawValue: "/~10")
        XCTAssertEqual(jsonPointer4.pointerValue.count, 1)
        XCTAssertEqual(jsonPointer4.pointerValue[0] as? String, "/0")
        let jsonPointer5 = try! JPSJsonPointer(rawValue: "/~1~0")
        XCTAssertEqual(jsonPointer5.pointerValue.count, 1)
        XCTAssertEqual(jsonPointer5.pointerValue[0] as? String, "/~")
        let jsonPointer6 = try! JPSJsonPointer(rawValue: "/~1/~0")
        XCTAssertEqual(jsonPointer6.pointerValue.count, 2)
        XCTAssertEqual(jsonPointer6.pointerValue[0] as? String, JPSConstants.JsonPointer.Delimiter)
        XCTAssertEqual(jsonPointer6.pointerValue[1] as? String, JPSConstants.JsonPointer.EscapeCharater)
        let jsonPointer7 = try! JPSJsonPointer(rawValue: "/~0/~1")
        XCTAssertEqual(jsonPointer7.pointerValue.count, 2)
        XCTAssertEqual(jsonPointer7.pointerValue[0] as? String, JPSConstants.JsonPointer.EscapeCharater)
        XCTAssertEqual(jsonPointer7.pointerValue[1] as? String, JPSConstants.JsonPointer.Delimiter)
        
    }
    
    //    The reference token then modifies which value is referenced according
    //    to the following scheme:
    //
    //    o  If the currently referenced value is a JSON object, the new
    //    referenced value is the object member with the name identified by
    //    the reference token.  The member name is equal to the token if it
    //    has the same number of Unicode characters as the token and their
    //    code points are byte-by-byte equal.  No Unicode character
    //    normalization is performed.  If a referenced member name is not
    //    unique in an object, the member that is referenced is undefined,
    //    and evaluation fails (see below).
    
    func testIfPointerIdentifiesObjectInJson() {
        let json = JSON(data: " { \"a\": { \"b\": \"bla\" } } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let pointer = try! JPSJsonPointer(rawValue: "/a")
        let retrievedJson = try! JPSJsonPointer.identifySubJsonForPointer(pointer, inJson: json)
        let expectedJson = JSON(data: " { \"b\": \"bla\" } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(retrievedJson, expectedJson)
    }
    
    func testIfInvalidPointerLeadsToError() {
        let json = JSON(data: " { \"a\": { \"b\": \"bla\" } } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let pointer = try! JPSJsonPointer(rawValue: "/b")
        do {
            let _ = try JPSJsonPointer.identifySubJsonForPointer(pointer, inJson: json)
            XCTFail("Unreachable code. Invalid pointer should raise an error.")
        } catch {
            // Expected behaviour.
        }
    }
    
    func testIfPointerIdentifiesArrayInJson() {
        let json = JSON(data: " { \"a\": [ { \"c\" : \"foo\" }, \"b\" ] } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let pointer = try! JPSJsonPointer(rawValue: "/a/0")
        let retrievedJson = try! JPSJsonPointer.identifySubJsonForPointer(pointer, inJson: json)
        let expectedJson = JSON(data: " { \"c\" : \"foo\" } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(retrievedJson, expectedJson)
    }
    
    func testIfPointerIdentifiesArrayInJson2() {
        let json = JSON(data: " { \"a\": [ { \"c\" : [ \"0\", \"1\", \"2\", { \"foo\" : \"bar\" }, \"4\" ] }, \"b\" ] } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let pointer = try! JPSJsonPointer(rawValue: "/a/0/c/3")
        let retrievedJson = try! JPSJsonPointer.identifySubJsonForPointer(pointer, inJson: json)
        let expectedJson = JSON(data: " { \"foo\" : \"bar\" } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(retrievedJson, expectedJson)
    }
    
    
//    o  If the currently referenced value is a JSON array, the reference
//    token MUST contain either:
//    
//    *  characters comprised of digits (see ABNF below; note that
//    leading zeros are not allowed) that represent an unsigned
//    base-10 integer value, making the new referenced value the
//    array element with the zero-based index identified by the
//    token, or
//    
//    *  exactly the single character "-", making the new referenced
//    value the (nonexistent) member after the last array element.
//    
//    The ABNF syntax for array indices is:
//    
//    array-index = %x30 / ( %x31-39 *(%x30-39) )
//    ; "0", or digits without a leading "0"
    
    func testIfPointerIdentifiesEndOfArrayTokenInJson() {
        let json = JSON(data: " { \"a\": [ \"b\", { \"c\" : \"foo\" } ] } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let pointer = try! JPSJsonPointer(rawValue: "/a/-")
        let retrievedJson = try! JPSJsonPointer.identifySubJsonForPointer(pointer, inJson: json)
        let expectedJson = JSON(data: " { \"c\" : \"foo\" } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(retrievedJson, expectedJson)
    }
    
    func testIfInvalidArrayPointerRaisesError() {
        let json = JSON(data: " { \"a\": \"b\", \"c\" : \"foo\" ] } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let pointer = try! JPSJsonPointer(rawValue: "/a/-")
        do {
            let _ = try JPSJsonPointer.identifySubJsonForPointer(pointer, inJson: json)
            XCTFail("Unreachable code. Invalid pointer should raise an error.")
        } catch {
            // Expected behaviour.
        }
    }
    
//    
//    Implementations will evaluate each reference token against the
//    document's contents and will raise an error condition if it fails to
//    resolve a concrete value for any of the JSON pointer's reference
//    tokens.  For example, if an array is referenced with a non-numeric
//    token, an error condition will be raised.  See Section 7 for details.
//    
//    Note that the use of the "-" character to index an array will always
//    result in such an error condition because by definition it refers to
//    a nonexistent array element.  Thus, applications of JSON Pointer need
//    to specify how that character is to be handled, if it is to be
//    useful.
//    
//    Any error condition for which a specific action is not defined by the
//    JSON Pointer application results in termination of evaluation.
    
    
}


// MARK: - chapter 5 tests

extension JPSJsonPointerTests {
    
    func testExamplesFromRFC() {
        let jsonString = "{        \"foo\": [\"bar\", \"baz\"],        \"\\\\\": 42,        \"a/b\": 1,        \"c%d\": 2,        \"e^f\": 3,        \"g|h\": 4,        \"i//j\": 5,        \"k\\\"l\": 6,        \" \": 7,        \"m~n\": 8    }"
        let json = JSON(data: jsonString.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        let pointer0 = try! JPSJsonPointer(rawValue: "/foo")
        let retrievedJson0 = try! JPSJsonPointer.identifySubJsonForPointer(pointer0, inJson: json)
        let expectedJson0 = JSON(data: " [\"bar\", \"baz\"] ".dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(retrievedJson0, expectedJson0)
        
        let pointer1 = try! JPSJsonPointer(rawValue: "/foo/0")
        let retrievedJson1 = try! JPSJsonPointer.identifySubJsonForPointer(pointer1, inJson: json)
        XCTAssertEqual(retrievedJson1.stringValue, "bar")
        
        let pointer2 = try! JPSJsonPointer(rawValue: "/\\")
        let retrievedJson2 = try! JPSJsonPointer.identifySubJsonForPointer(pointer2, inJson: json)
        XCTAssertEqual(retrievedJson2.intValue, 42)
        
        let pointer3 = try! JPSJsonPointer(rawValue: "/a~1b")
        let retrievedJson3 = try! JPSJsonPointer.identifySubJsonForPointer(pointer3, inJson: json)
        XCTAssertEqual(retrievedJson3.intValue, 1)
        
        let pointer4 = try! JPSJsonPointer(rawValue: "/c%d")
        let retrievedJson4 = try! JPSJsonPointer.identifySubJsonForPointer(pointer4, inJson: json)
        XCTAssertEqual(retrievedJson4.intValue, 2)
        
        let pointer5 = try! JPSJsonPointer(rawValue: "/e^f")
        let retrievedJson5 = try! JPSJsonPointer.identifySubJsonForPointer(pointer5, inJson: json)
        XCTAssertEqual(retrievedJson5.intValue, 3)
        
        let pointer6 = try! JPSJsonPointer(rawValue: "/g|h")
        let retrievedJson6 = try! JPSJsonPointer.identifySubJsonForPointer(pointer6, inJson: json)
        XCTAssertEqual(retrievedJson6.intValue, 4)
        
        let pointer7 = try! JPSJsonPointer(rawValue: "/i~1~1j")
        let retrievedJson7 = try! JPSJsonPointer.identifySubJsonForPointer(pointer7, inJson: json)
        XCTAssertEqual(retrievedJson7.intValue, 5)
        
        let pointer8 = try! JPSJsonPointer(rawValue: "/k\"l")
        let retrievedJson8 = try! JPSJsonPointer.identifySubJsonForPointer(pointer8, inJson: json)
        XCTAssertEqual(retrievedJson8.intValue, 6)
        
        let pointer9 = try! JPSJsonPointer(rawValue: "/ ")
        let retrievedJson9 = try! JPSJsonPointer.identifySubJsonForPointer(pointer9, inJson: json)
        XCTAssertEqual(retrievedJson9.intValue, 7)
        
        let pointer10 = try! JPSJsonPointer(rawValue: "/m~0n")
        let retrievedJson10 = try! JPSJsonPointer.identifySubJsonForPointer(pointer10, inJson: json)
        XCTAssertEqual(retrievedJson10.intValue, 8)
    }
    
    func testRetrievingTheWholeDocument() {
        let json = JSON(data: " { \"a\": [ \"b\", { \"c\" : \"foo\" } ] } ".dataUsingEncoding(NSUTF8StringEncoding)!)
        let pointer = try! JPSJsonPointer(rawValue: "")
        let retrievedJson = try! JPSJsonPointer.identifySubJsonForPointer(pointer, inJson: json)
        XCTAssertEqual(retrievedJson, json)
    }
    
}


// MARK: - chapter 6 tests

extension JPSJsonPointerTests {
    
    
//
//    6.  URI Fragment Identifier Representation
//    
//    A JSON Pointer can be represented in a URI fragment identifier by
//    encoding it into octets using UTF-8 [RFC3629], while percent-encoding
//    those characters not allowed by the fragment rule in [RFC3986].
//    
//    Note that a given media type needs to specify JSON Pointer as its
//    fragment identifier syntax explicitly (usually, in its registration
//    [RFC6838]).  That is, just because a document is JSON does not imply
//    that JSON Pointer can be used as its fragment identifier syntax.  In
//    particular, the fragment identifier syntax for application/json is
//    not JSON Pointer.

//    
//    Given the same example document as above, the following URI fragment
//    identifiers evaluate to the accompanying values:
//    
//    #            // the whole document
//    #/foo        ["bar", "baz"]
//    #/foo/0      "bar"
//    #/           0
//    #/a~1b       1
//    #/c%25d      2
//    #/e%5Ef      3
//    #/g%7Ch      4
//    #/i%5Cj      5
//    #/k%22l      6
//    #/%20        7
//    #/m~0n       8
    
    
    
}


// MARK: - chapter 7 tests

extension JPSJsonPointerTests {
    
    
//
//    7.  Error Handling
//    
//    In the event of an error condition, evaluation of the JSON Pointer
//    fails to complete.
//    
//    Error conditions include, but are not limited to:
//    
//    o  Invalid pointer syntax
//    
//    o  A pointer that references a nonexistent value
//    
//    This specification does not define how errors are handled.  An
//    application of JSON Pointer SHOULD specify the impact and handling of
//    each type of error.
//    
//    For example, some applications might stop pointer processing upon an
//    error, while others may attempt to recover from missing values by
//    inserting default ones.
    
    
    
}


// MARK: - chapter 8 tests

extension JPSJsonPointerTests {
    
    
//
//    8.  Security Considerations
//    
//    A given JSON Pointer is not guaranteed to reference an actual JSON
//    value.  Therefore, applications using JSON Pointer should anticipate
//    this situation by defining how a pointer that does not resolve ought
//    to be handled.
//    
//    Note that JSON pointers can contain the NUL (Unicode U+0000)
//    character.  Care is needed not to misinterpret this character in
//    programming languages that use NUL to mark the end of a string.
//    
//    
    
}
