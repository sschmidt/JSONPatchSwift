//===----------------------------------------------------------------------===//
//
// This source file is part of the JSONPatchSwift open source project.
//
// Copyright (c) 2015 EXXETA AG
// Licensed under Apache License v2.0
//
//
//===----------------------------------------------------------------------===//

import Foundation

// swiftlint:disable nesting
struct JPSConstants {
    
    struct JsonPatch {
        
        struct Parameter {
            static let Op = "op"
            static let Path = "path"
            static let Value = "value"
            static let From = "from"
        }
        
        struct InitialisationErrorMessages {
            static let PatchEncoding = "Could not encode patch."
            static let PatchWithEmptyError = "Patch array does not contain elements."
            static let InvalidRootElement = "Root element is not an array of dictionaries or a single dictionary."
            static let OpElementNotFound = "Could not find 'op' element."
            static let PathElementNotFound = "Could not find 'path' element."
            static let InvalidOperation = "Operation is invalid."
            static let FromElementNotFound = "Could not find 'from' element."
            static let ValueElementNotFound = "Could not find 'value' element."
        }
        
        struct ErrorMessages {
            static let ValidationError = "Could not validate JSON."
        }
        
    }
    
    
    
    struct Operation {
        static let Add = "add"
        static let Remove = "remove"
        static let Replace = "replace"
        static let Move = "move"
        static let Copy = "copy"
        static let Test = "test"
    }
    
    struct JsonPointer {
        static let Delimiter = "/"
        static let EndOfArrayMarker = "-"
        static let EmptyString = ""
        static let EscapeCharater = "~"
        static let EscapedDelimiter = "~1"
        static let EscapedEscapeCharacter = "~0"
    }
    
}
