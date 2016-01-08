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

// JavaScript Object Notation (JSON) Pointer
// https://tools.ietf.org/html/rfc6901

class JPSJsonPointerTests: XCTestCase {
    
}


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
            let _ = try JPSJsonPointer(rawValue: "/")
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
//    json-pointer    = *( "/" reference-token )
//    reference-token = *( unescaped / escaped )
//    unescaped       = %x00-2E / %x30-7D / %x7F-10FFFF
//    ; %x2F ('/') and %x7E ('~') are excluded from 'unescaped'
//    escaped         = "~" ( "0" / "1" )
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
        XCTAssertEqual(jsonPointer1.pointerValue[0], "/")
        let jsonPointer2 = try! JPSJsonPointer(rawValue: "/~0")
        XCTAssertEqual(jsonPointer2.pointerValue.count, 1)
        XCTAssertEqual(jsonPointer2.pointerValue[0], "~")
        let jsonPointer3 = try! JPSJsonPointer(rawValue: "/~01")
        XCTAssertEqual(jsonPointer3.pointerValue.count, 1)
        XCTAssertEqual(jsonPointer3.pointerValue[0], "~1")
        let jsonPointer4 = try! JPSJsonPointer(rawValue: "/~10")
        XCTAssertEqual(jsonPointer4.pointerValue.count, 1)
        XCTAssertEqual(jsonPointer4.pointerValue[0], "/0")
        let jsonPointer5 = try! JPSJsonPointer(rawValue: "/~1~0")
        XCTAssertEqual(jsonPointer5.pointerValue.count, 1)
        XCTAssertEqual(jsonPointer5.pointerValue[0], "/~")
        let jsonPointer6 = try! JPSJsonPointer(rawValue: "/~1/~0")
        XCTAssertEqual(jsonPointer6.pointerValue.count, 2)
        XCTAssertEqual(jsonPointer6.pointerValue[0], "/")
        XCTAssertEqual(jsonPointer6.pointerValue[1], "~")
        let jsonPointer7 = try! JPSJsonPointer(rawValue: "/~0/~1")
        XCTAssertEqual(jsonPointer7.pointerValue.count, 2)
        XCTAssertEqual(jsonPointer7.pointerValue[0], "~")
        XCTAssertEqual(jsonPointer7.pointerValue[1], "/")
        
    }
    
//    
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
//    
//    

//    
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
    
//
//    5.  JSON String Representation
//    
//    A JSON Pointer can be represented in a JSON string value.  Per
//    [RFC4627], Section 2.5, all instances of quotation mark '"' (%x22),
//    reverse solidus '\' (%x5C), and control (%x00-1F) characters MUST be
//    escaped.
//    
//    Note that before processing a JSON string as a JSON Pointer,
//    backslash escape sequences must be unescaped.
//    

//    
//    For example, given the JSON document
//    
//    {
//    "foo": ["bar", "baz"],
//    "": 0,
//    "a/b": 1,
//    "c%d": 2,
//    "e^f": 3,
//    "g|h": 4,
//    "i\\j": 5,
//    "k\"l": 6,
//    " ": 7,
//    "m~n": 8
//    }
//    
//    The following JSON strings evaluate to the accompanying values:
//    
//    ""           // the whole document
//    "/foo"       ["bar", "baz"]
//    "/foo/0"     "bar"
//    "/"          0
//    "/a~1b"      1
//    "/c%d"       2
//    "/e^f"       3
//    "/g|h"       4
//    "/i\\j"      5
//    "/k\"l"      6
//    "/ "         7
//    "/m~0n"      8
    
    
    
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
