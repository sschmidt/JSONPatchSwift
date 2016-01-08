//===----------------------------------------------------------------------===//
//
// This source file is part of the JSONPatchSwift open source project.
//
// Copyright (c) 2015 EXXETA AG
// Licensed under Apache License v2.0
//
//
//===----------------------------------------------------------------------===//

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
    
}
