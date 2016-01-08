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

enum JPSJsonPointerError: ErrorType {
    case ValueDoesNotContainDelimiter
    case NonEmptyPointerDoesNotStartWithDelimiter
    case ContainsEmptyReferenceToken
}

struct JPSJsonPointer {
    
    let rawValue: String
    let pointerValue: [String]
    
}

extension JPSJsonPointer {

    init(rawValue: String) throws {
        guard rawValue.isEmpty || rawValue.containsString("/") else {
            throw JPSJsonPointerError.ValueDoesNotContainDelimiter
        }
        guard rawValue.isEmpty || rawValue.hasPrefix("/") else {
            throw JPSJsonPointerError.NonEmptyPointerDoesNotStartWithDelimiter
        }
        guard rawValue.isEmpty || !rawValue.componentsSeparatedByString("/").dropFirst().contains("") else {
            throw JPSJsonPointerError.ContainsEmptyReferenceToken
        }
        
        let pointerValueWithoutFirstDelimiter = Array(rawValue.componentsSeparatedByString("/").dropFirst())
        let pointerValueAfterDecodingDelimiter = pointerValueWithoutFirstDelimiter.map { $0.stringByReplacingOccurrencesOfString("~1", withString: "/") }
        let pointerValue = pointerValueAfterDecodingDelimiter.map { $0.stringByReplacingOccurrencesOfString("~0", withString: "~") }
        
        self.init(rawValue: rawValue, pointerValue: pointerValue)
    }
    
}

extension JPSJsonPointer {

    static func identifySubJsonForPointer(pointer: JPSJsonPointer, inJson json: JSON) -> JSON {
        var tempJson = json
        for i in 0..<pointer.pointerValue.count {
            tempJson = tempJson[pointer.pointerValue[i]]
        }
        return tempJson
    }
    
}
