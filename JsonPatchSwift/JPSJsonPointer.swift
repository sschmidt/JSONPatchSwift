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
}

struct JPSJsonPointer {
    
    let value: String
    
    init(value: String) throws {
        guard value.isEmpty || value.containsString("/") else {
            throw JPSJsonPointerError.ValueDoesNotContainDelimiter
        }
        self.value = value
    }
    
}
