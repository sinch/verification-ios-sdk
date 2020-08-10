//
//  VerificationError.swift
//  Verification
//
//  Created by Aleksander Wojcik on 13/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Enumeration defining error that SINCH Verifications API can throw.
public enum SDKError: LocalizedError {
    
    /// One of the argument that was passed to the function was invalid.
    case illegalArgument(message: String)
    
    /// Error indicating that given encodable object could not be encoded properly.
    case encoding(encodable: Encodable)
    
    /// SDK representation of Sinch REST API error response.
    case apiCall(data: ApiErrorData)
    
    /// Unexpected error
    case unexpected(message: String)
    
    public var errorDescription: String? {
        switch self {
        case .illegalArgument(let message):
            return message
        case .encoding(let encodable):
            return "Encoding of \(encodable) failed"
        case .apiCall(let data):
            return data.message ?? "Sinch api returned an error without message"
        case .unexpected(let message):
            return message
        }
    }

}
