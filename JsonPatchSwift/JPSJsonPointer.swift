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
    case EvaluationFailed
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
        guard rawValue.isEmpty || "/" == rawValue || !rawValue.componentsSeparatedByString("/").dropFirst().contains("") else {
            throw JPSJsonPointerError.ContainsEmptyReferenceToken
        }
        
        let pointerValueWithoutFirstDelimiter = Array(rawValue.componentsSeparatedByString("/").dropFirst())
        let pointerValueAfterDecodingDelimiter = pointerValueWithoutFirstDelimiter.map { $0.stringByReplacingOccurrencesOfString("~1", withString: "/") }
        let pointerValue = pointerValueAfterDecodingDelimiter.map { $0.stringByReplacingOccurrencesOfString("~0", withString: "~") }
        
        self.init(rawValue: rawValue, pointerValue: pointerValue)
    }
    
}


//protocol JPSJsonPointerEvaluationResult {}
//extension JSON: JPSJsonPointerEvaluationResult {}
//extension String: JPSJsonPointerEvaluationResult {}
//extension Int: JPSJsonPointerEvaluationResult {}
//extension Float: JPSJsonPointerEvaluationResult {}
//extension Double: JPSJsonPointerEvaluationResult {}
//extension Bool: JPSJsonPointerEvaluationResult {}

extension JPSJsonPointer {

    static func identifySubJsonForPointer(pointer: JPSJsonPointer, inJson json: JSON) throws -> JSON {
        var tempJson = json
        
        guard "/" != pointer.rawValue else {
            return json
        }
        
        for i in 0..<pointer.pointerValue.count {
            if tempJson.type == .Array {
                if "-" == pointer.pointerValue[i] {
                    tempJson = tempJson.arrayValue.last!
                } else {
                    tempJson = tempJson[Int(pointer.pointerValue[i])!]
                }
            } else {
                tempJson = tempJson[pointer.pointerValue[i]]
            }
        }
        if tempJson == nil {
            throw JPSJsonPointerError.EvaluationFailed
        }
        return tempJson
    }
    
}
