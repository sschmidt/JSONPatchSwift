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
    
    let value: String
    
    init(value: String) throws {
        guard value.isEmpty || value.containsString("/") else {
            throw JPSJsonPointerError.ValueDoesNotContainDelimiter
        }
        guard value.isEmpty || value.hasPrefix("/") else {
            throw JPSJsonPointerError.NonEmptyPointerDoesNotStartWithDelimiter
        }
        guard value.isEmpty || !value.componentsSeparatedByString("/").dropFirst().contains("") else {
            throw JPSJsonPointerError.ContainsEmptyReferenceToken
        }
        
        self.value = value
    }
    
}
