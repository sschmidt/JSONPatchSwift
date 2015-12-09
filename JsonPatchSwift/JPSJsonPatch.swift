//
//  JPSJsonPatch.swift
//  JsonPatchSwift
//
//  Created by Dominic Frei on 08/12/2015.
//  Copyright © 2015 Dominic Frei. All rights reserved.
//

import SwiftyJSON

enum JPSJsonPatchInitialisationError: ErrorType {
    case InvalidJsonFormat(message: String?)
    case InvalidPatchFormat(message: String?)
    case UnexpectedError
}

struct JPSJsonPatch {
    
    let operations: [JPSOperation]
    
    init(_ patch: String) throws {
        guard let data = patch.dataUsingEncoding(NSUTF8StringEncoding) else {
            throw JPSJsonPatchInitialisationError.InvalidJsonFormat(message: "Could not encode patch.")
        }
        
        let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
        
        print(json)
        
        if let json = json as? [String: AnyObject] {
            self.operations = [try JPSJsonPatch.extractOperationFromJson(json)]
            
        } else if let json = json as? [AnyObject] {
            var operationArray = [JPSOperation]()
            for i in 0..<json.count {
                guard let operation = json[i] as? [String: AnyObject] else {
                    throw JPSJsonPatchInitialisationError.InvalidJsonFormat(message: "Array does not contain dictionaries")
                }
                operationArray.append(try JPSJsonPatch.extractOperationFromJson(operation))
            }
            self.operations = operationArray
        } else {
            // All other types are not a valid JSON Patch Operation.
            print(json)
            throw JPSJsonPatchInitialisationError.InvalidPatchFormat(message: "Root element is not an array of dictionaries or a single dictionary.")
        }
        
    }
    
    private static func extractOperationFromJson(json: [String: AnyObject]) throws -> JPSOperation {
        guard let operation = json["op"] as? String else {
            throw JPSJsonPatchInitialisationError.InvalidPatchFormat(message: "Could not find 'op' element.")
        }
        guard let _ = json["path"] as? String else {
            throw JPSJsonPatchInitialisationError.InvalidPatchFormat(message: "Could not find 'path' element.")
        }
        switch JPSOperationType(rawValue: operation)! {
        case .Add: return JPSOperation(type: JPSOperationType.Add)
        case .Remove: return JPSOperation(type: JPSOperationType.Remove)
        case .Replace: return JPSOperation(type: JPSOperationType.Replace)
        case .Move: return JPSOperation(type: JPSOperationType.Move)
        case .Copy: return JPSOperation(type: JPSOperationType.Copy)
        case .Test: return JPSOperation(type: JPSOperationType.Test)
        }
    }
    
}

enum JPSOperationType: String {
    case Add = "add"
    case Remove = "remove"
    case Replace = "replace"
    case Move = "move"
    case Copy = "copy"
    case Test = "test"
}

struct JPSOperation {
    
    let type: JPSOperationType
    
}
