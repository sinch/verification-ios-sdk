//
//  EncodableExtensions.swift
//  Verification
//
//  Created by Aleksander Wojcik on 15/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

typealias JSON = [String: Any]

extension JSONEncoder {
    
    static var standard: JSONEncoder {
        let decoder = JSONEncoder()
        decoder.keyEncodingStrategy = .convertToSnakeCase
        return decoder
    }
    
}

extension Encodable {
        
    var asDictionary: JSON {
        do {
            return try asDictionaryThrowable()
        } catch {
            debugPrint("\(self) couldn't be cast to parameters")
        }
        return [:]
    }
    
    func asDictionaryThrowable() throws -> JSON  {
        let data = try Self.encoder.encode(self)
        let serializedObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        if let dictionary = serializedObject as? JSON {
            return dictionary
        } else if let singleObjectArray = serializedObject as? NSArray,
            let json = singleObjectArray.firstObject,
            let dictionary = json as? JSON {
            return dictionary
        } else {
            throw SDKError.encoding(encodable: self)
        }
    }
    
    var asData: Data? {
        do {
            let json = try self.asDictionaryThrowable()
            return try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        } catch {
            return nil
        }
    }
    
    private static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        return encoder
    }
}

extension KeyedDecodingContainer {
    
    func decodeAsURLIfPossible(forKey key: Key) throws -> URL? {
        let path = try decode(String.self, forKey: key)
        return URL(string: path)
    }
    
    func decodeAsURL(forKey key: Key) throws -> URL {
        return try decodeAsURLIfPossible(forKey: key)!
    }
}
