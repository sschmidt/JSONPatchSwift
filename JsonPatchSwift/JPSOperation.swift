//===----------------------------------------------------------------------===//
//
// This source file is part of the JSONPatchSwift open source project.
//
// Copyright (c) 2015 EXXETA AG
// Licensed under Apache License v2.0
//
//
//===----------------------------------------------------------------------===//

func == (lhs: JPSOperation, rhs: JPSOperation) -> Bool {
    return lhs.type == rhs.type
}

struct JPSOperation {
    
    enum JPSOperationType: String {
        case Add = "add"
        case Remove = "remove"
        case Replace = "replace"
        case Move = "move"
        case Copy = "copy"
        case Test = "test"
    }
    
    let type: JPSOperationType
    let pointer: JPSJsonPointer
    
}
