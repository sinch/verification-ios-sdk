//
//  DecodableExtensions.swift
//  Verification
//
//  Created by Aleksander Wojcik on 17/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

extension Decodable {
    
    static func make(from json: JSON) throws -> Self {
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        return try decoder.decode(Self.self, from: data)
    }
    
    static func make(from data: Data) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
    
    static func makeSafe(from data: Data) -> Self? {
        do {
            return try Self.make(from: data)
        } catch {
            return nil
        }
    }
    
    private static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
}
