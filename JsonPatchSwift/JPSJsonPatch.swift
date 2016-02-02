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

struct JPSJsonPatch {
    
    enum JPSJsonPatchInitialisationError: ErrorType {
        case InvalidJsonFormat(message: String?)
        case InvalidPatchFormat(message: String?)
        case UnexpectedError
    }
    
    let operations: [JPSOperation]
    
    init(_ patch: String) throws {
        
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


// MARK: - Using the patch

extension JPSJsonPatch {
    
    static func applyPatch(jsonPatch: JPSJsonPatch, toJson json: JSON) -> JSON {
        switch jsonPatch.operations[0].type {
        case .Add: return JPSJsonPatch.add(jsonPatch, toJson: json)
        case .Remove: return JPSJsonPatch.remove(jsonPatch, toJson: json)
        case .Replace: return JPSJsonPatch.replace(jsonPatch, toJson: json)
        case .Move: return JPSJsonPatch.move(jsonPatch, toJson: json)
        case .Copy: return JPSJsonPatch.copy(jsonPatch, toJson: json)
        case .Test: return JPSJsonPatch.test(jsonPatch, toJson: json)
        }
    }
    
    static func add(jsonPatch: JPSJsonPatch, toJson json: JSON) -> JSON {
        let pointer = jsonPatch.operations[0].pointer
        var patchedJson = json
        if jsonPatch.operations[0].pointer.rawValue.isEmpty {
            patchedJson = jsonPatch.operations[0].value
        } else {
            if patchedJson[Array(pointer.pointerValue.dropLast())].type == .Array && pointer.pointerValue.last is Int {
                //                let
                
            } else {
                patchedJson[pointer.pointerValue] = jsonPatch.operations[0].value
            }
        }
        return patchedJson
    }
    
    static func remove(jsonPatch: JPSJsonPatch, toJson json: JSON) -> JSON {
        return json
    }
    
    static func replace(jsonPatch: JPSJsonPatch, toJson json: JSON) -> JSON {
        return json
    }
    
    static func move(jsonPatch: JPSJsonPatch, toJson json: JSON) -> JSON {
        return json
    }
    
    static func copy(jsonPatch: JPSJsonPatch, toJson json: JSON) -> JSON {
        return json
    }
    
    static func test(jsonPatch: JPSJsonPatch, toJson json: JSON) -> JSON {
        return json
    }
    
    static func nextSubvalueInJson(inout json: JSON, forPointerValue pointer: JPSJsonPointer) -> JSON {
        guard let firstPointerValue = pointer.pointerValue.first else {
            return json
        }
        if let firstPointerValue = firstPointerValue as? Int where json[firstPointerValue].type == .Array {
            
        }
        return json
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
        
        let value = json[JPSConstants.JsonPatch.Parameter.Value]
        let pointer = try JPSJsonPointer(rawValue: path)
        
        return JPSOperation(type: operationType, pointer: pointer, value: value)
    }
    
}
