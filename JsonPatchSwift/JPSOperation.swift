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

func == (lhs: JPSOperation, rhs: JPSOperation) -> Bool {
    return lhs.type == rhs.type
}

public struct JPSOperation {
    
    public enum JPSOperationType: String {
        case Add = "add"
        case Remove = "remove"
        case Replace = "replace"
        case Move = "move"
        case Copy = "copy"
        case Test = "test"
    }
    
    let type: JPSOperationType
    let pointer: JPSJsonPointer
    let value: JSON
    let from: JPSJsonPointer?
}
