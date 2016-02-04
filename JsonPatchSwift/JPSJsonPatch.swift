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
    
    @warn_unused_result static func applyPatch(jsonPatch: JPSJsonPatch, toJson json: JSON) throws -> JSON {
        let operation = jsonPatch.operations[0] // TODO - iterate all operations
        switch operation.type {
        case .Add: return try JPSJsonPatch.add(operation, toJson: json)
        case .Remove: return try JPSJsonPatch.remove(operation, toJson: json)
        case .Replace: return try JPSJsonPatch.replace(operation, toJson: json)
        case .Move: return try JPSJsonPatch.move(operation, toJson: json)
        case .Copy: return try JPSJsonPatch.copy(operation, toJson: json)
        case .Test: return try JPSJsonPatch.test(operation, toJson: json)
        }
    }

    static func add(operation: JPSOperation, toJson json: JSON) throws -> JSON {

        guard 0 < operation.pointer.pointerValue.count else {
            return operation.value
        }

        return try JPSJsonPatch.applyOperation(json, pointer: operation.pointer) {
            (traversedJson, pointer) -> JSON in
            
            var newJson = traversedJson
            if var jsonAsDictionary = traversedJson.dictionaryObject, let index = pointer.pointerValue[0] as? String {
                jsonAsDictionary[index] = operation.value.object
                newJson.object = jsonAsDictionary
            }
            if var jsonAsArray = traversedJson.arrayObject, let indexString = pointer.pointerValue[0] as? String, let index = Int(indexString) {
                jsonAsArray.insert(operation.value.object, atIndex: index)
                newJson.object = jsonAsArray
            }
            return newJson
        }
    }
    
    static func remove(operation: JPSOperation, toJson json: JSON) throws -> JSON {
        return try JPSJsonPatch.applyOperation(json, pointer: operation.pointer) {
            (traversedJson: JSON, pointer: JPSJsonPointer) in
                var newJson = traversedJson
                if var dictionary = traversedJson.dictionaryObject {
                    dictionary.removeValueForKey(pointer.pointerValue[0] as! String)
                    newJson.object = dictionary
                }
                if var arr = traversedJson.arrayObject {
                    arr.removeAtIndex(Int(pointer.pointerValue[0] as! String)!)
                    newJson.object = arr
                }
                return newJson
        }
    }
    
    static func replace(operation: JPSOperation, toJson json: JSON) throws -> JSON {
        return try JPSJsonPatch.applyOperation(json, pointer: operation.pointer) {
            (traversedJson: JSON, pointer: JPSJsonPointer) in
            var newJson = traversedJson
            if var dictionary = traversedJson.dictionaryObject {
                let key = pointer.pointerValue[0] as! String
                dictionary[key] = operation.value.object
                newJson.object = dictionary
            }
            if var arr = traversedJson.arrayObject {
                let key = Int(pointer.pointerValue[0] as! String)!
                arr[key] = operation.value.object
                newJson.object = arr
            }
            return newJson
        }
    }
    
    static func move(operation: JPSOperation, toJson json: JSON) throws -> JSON {
        var resultJson = json

        try JPSJsonPatch.applyOperation(json, pointer: operation.from!) {
            (traversedJson: JSON, pointer: JPSJsonPointer) in
            
            // From: http://tools.ietf.org/html/rfc6902#section-4.3
            //    This operation is functionally identical to a "remove" operation for
            //    a value, followed immediately by an "add" operation at the same
            //    location with the replacement value.

            // remove
            let removeOperation = JPSOperation(type: JPSOperation.JPSOperationType.Remove, pointer: operation.from!, value: resultJson, from: operation.from)
            resultJson = try JPSJsonPatch.remove(removeOperation, toJson: resultJson)

            // add
            var jsonToAdd = traversedJson[pointer.pointerValue];
            if traversedJson.type == .Array {
                jsonToAdd = traversedJson[Int(pointer.pointerValue[0] as! String)!]
            }
            let addOperation = JPSOperation(type: JPSOperation.JPSOperationType.Add, pointer: operation.pointer, value: jsonToAdd, from: operation.from)
            resultJson = try JPSJsonPatch.add(addOperation, toJson: resultJson)

            return traversedJson
        }

        return resultJson
    }
    
    static func copy(operation: JPSOperation, toJson json: JSON) throws -> JSON {
        var resultJson = json
        
        try JPSJsonPatch.applyOperation(json, pointer: operation.from!) {
            (traversedJson: JSON, pointer: JPSJsonPointer) in
            var jsonToAdd = traversedJson[pointer.pointerValue];
            if traversedJson.type == .Array {
                jsonToAdd = traversedJson[Int(pointer.pointerValue[0] as! String)!]
            }
            let addOperation = JPSOperation(type: JPSOperation.JPSOperationType.Add, pointer: operation.pointer, value: jsonToAdd, from: operation.from)
            resultJson = try JPSJsonPatch.add(addOperation, toJson: resultJson)
            return traversedJson
        }
        
        return resultJson

    }
    
    static func test(operation: JPSOperation, toJson json: JSON) throws -> JSON {
        return json
    }

    static func applyOperation(json: JSON?, pointer: JPSJsonPointer, operation: ((JSON, JPSJsonPointer) throws -> JSON)) throws -> JSON {
        let newJson = json!
        if(pointer.pointerValue.count == 1) {
            return try operation(newJson, pointer)
        } else {
            if var arr = newJson.array {
                let key = Int(pointer.pointerValue[0] as! String)!
                arr[key] = try applyOperation(arr[key], pointer: JPSJsonPointer.traverse(pointer), operation: operation)
                return JSON(arr)
            }
            if var dictionary = newJson.dictionary {
                let key = pointer.pointerValue[0] as! String
                dictionary[key] = try applyOperation(dictionary[key], pointer: JPSJsonPointer.traverse(pointer), operation: operation)
                return JSON(dictionary)
            }
        }
        return newJson
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
