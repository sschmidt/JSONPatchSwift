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

func == (lhs: JPSJsonPatch, rhs: JPSJsonPatch) -> Bool {
    
    guard lhs.operations.count == rhs.operations.count else { return false }
    
    for i in 0..<lhs.operations.count {
        if !(lhs.operations[i] == rhs.operations[i]) {
            return false
        }
    }
    
    return true
}

public struct JPSJsonPatch {
    
    public enum JPSJsonPatchInitialisationError: ErrorType {
        case InvalidJsonFormat(message: String?)
        case InvalidPatchFormat(message: String?)
        case UnexpectedError
    }
    
    let operations: [JPSOperation]
    
    public init(_ patch: String) throws {
        
        // Get the JSON
        guard let data = patch.dataUsingEncoding(NSUTF8StringEncoding) else {
            throw JPSJsonPatchInitialisationError.InvalidJsonFormat(message: JPSConstants.JsonPatch.InitialisationErrorMessages.PatchEncoding)
        }
        
        let json = JSON(data: data)
        
        // Check if there is an array of a dictionary as root element. Both are valid JSON patch documents.
        if json.type == .Dictionary {
            self.operations = [try JPSJsonPatch.extractOperationFromJson(json)]
            
        } else if json.type == .Array {
            guard 0 < json.count else {
                throw JPSJsonPatchInitialisationError.InvalidPatchFormat(message: JPSConstants.JsonPatch.InitialisationErrorMessages.PatchWithEmptyError)
            }
            var operationArray = [JPSOperation]()
            for i in 0..<json.count {
                let operation = json[i]
                operationArray.append(try JPSJsonPatch.extractOperationFromJson(operation))
            }
            self.operations = operationArray
            
        } else {
            // All other types are not a valid JSON Patch Operation.
            throw JPSJsonPatchInitialisationError.InvalidPatchFormat(message: JPSConstants.JsonPatch.InitialisationErrorMessages.InvalidRootElement)
        }
        
    }
    
}


// MARK: - Private functions

extension JPSJsonPatch {
    
    private static func extractOperationFromJson(json: JSON) throws -> JPSOperation {
        
        // The elements 'op' and 'path' are mandatory.
        guard let operation = json[JPSConstants.JsonPatch.Parameter.Op].string else {
            throw JPSJsonPatchInitialisationError.InvalidPatchFormat(message: JPSConstants.JsonPatch.InitialisationErrorMessages.OpElementNotFound)
        }
        guard let path = json[JPSConstants.JsonPatch.Parameter.Path].string else {
            throw JPSJsonPatchInitialisationError.InvalidPatchFormat(message: JPSConstants.JsonPatch.InitialisationErrorMessages.PathElementNotFound)
        }
        guard let operationType = JPSOperation.JPSOperationType(rawValue: operation) else {
            throw JPSJsonPatchInitialisationError.InvalidPatchFormat(message: JPSConstants.JsonPatch.InitialisationErrorMessages.InvalidOperation)
        }

        // 'from' element mandatory for .Move, .Copy operations
        var from: JPSJsonPointer?
        if operationType == .Move || operationType == .Copy {
            guard let fromValue = json[JPSConstants.JsonPatch.Parameter.From].string else {
                throw JPSJsonPatchInitialisationError.InvalidPatchFormat(message: JPSConstants.JsonPatch.InitialisationErrorMessages.FromElementNotFound)
            }
            from = try JPSJsonPointer(rawValue: fromValue)
        }

        // 'value' element mandatory for .Add, .Replace operations
        let value = json[JPSConstants.JsonPatch.Parameter.Value]
        // counterintuitive null check: https://github.com/SwiftyJSON/SwiftyJSON/issues/205
        if (operationType == .Add || operationType == .Replace) && value.null != nil {
            throw JPSJsonPatchInitialisationError.InvalidPatchFormat(message: JPSConstants.JsonPatch.InitialisationErrorMessages.ValueElementNotFound)
        }

        let pointer = try JPSJsonPointer(rawValue: path)
        return JPSOperation(type: operationType, pointer: pointer, value: value, from: from)
    }
    
}
