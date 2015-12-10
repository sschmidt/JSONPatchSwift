//
//  JPSJsonPatch.swift
//  JsonPatchSwift
//
//  Created by Dominic Frei on 08/12/2015.
//  Copyright © 2015 Dominic Frei. All rights reserved.
//

import SwiftyJSON

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
            throw JPSJsonPatchInitialisationError.InvalidJsonFormat(message: "Could not encode patch.")
        }
        let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
        guard true == NSJSONSerialization.isValidJSONObject(json) else {
            throw JPSJsonPatchInitialisationError.InvalidJsonFormat(message: "Invalid JSON format.")
        }
        
        // Check if there is an array of a dictionary as root element. Both are valid JSON patch documents.
        if let json = json as? [String: AnyObject] {
            self.operations = [try JPSJsonPatch.extractOperationFromJson(json)]
            
        } else if let json = json as? [AnyObject] {
            guard 0 < json.count else {
                throw JPSJsonPatchInitialisationError.InvalidPatchFormat(message: "Patch array does not contain elements.")
            }
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
            throw JPSJsonPatchInitialisationError.InvalidPatchFormat(message: "Root element is not an array of dictionaries or a single dictionary.")
        }
        
    }
    
    private static func extractOperationFromJson(json: [String: AnyObject]) throws -> JPSOperation {
        
        // The elements 'op' and 'path' are mandatory.
        guard let operation = json["op"] as? String else {
            throw JPSJsonPatchInitialisationError.InvalidPatchFormat(message: "Could not find 'op' element.")
        }
        guard let _ = json["path"] as? String else {
            throw JPSJsonPatchInitialisationError.InvalidPatchFormat(message: "Could not find 'path' element.")
        }
        
        switch JPSOperation.JPSOperationType(rawValue: operation)! {
        case .Add: return JPSOperation(type: JPSOperation.JPSOperationType.Add)
        case .Remove: return JPSOperation(type: JPSOperation.JPSOperationType.Remove)
        case .Replace: return JPSOperation(type: JPSOperation.JPSOperationType.Replace)
        case .Move: return JPSOperation(type: JPSOperation.JPSOperationType.Move)
        case .Copy: return JPSOperation(type: JPSOperation.JPSOperationType.Copy)
        case .Test: return JPSOperation(type: JPSOperation.JPSOperationType.Test)
        }
    }
    
}
