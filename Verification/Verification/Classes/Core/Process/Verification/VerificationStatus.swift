//
//  VerificationStatus.swift
//  Verification
//
//  Created by Aleksander Wojcik on 20/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Enum describing API status of the verification.
public enum VerificationStatus: String, Codable {
    
    /// Verification is ongoing.
    case pending = "PENDING"
    
    /// Verification has been successfully processed.
    case successful = "SUCCESSFUL"
    
    /// Verification attempt was made, but the number was not verified.
    /// Encoded as the API value `FAIL`. `FAILED` is also accepted when decoding.
    case failed = "FAIL"
    
    /// Verification attempt was denied by Sinch or your backend.
    case denied = "DENIED"
    
    /// Verification attempt was aborted.
    case aborted = "ABORTED"
    
    /// Verification attempt could not be completed due to a network error or the number being unreachable.
    case error = "ERROR"
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        switch raw.uppercased() {
        case "PENDING":
            self = .pending
        case "SUCCESSFUL":
            self = .successful
        case "FAIL", "FAILED":
            self = .failed
        case "DENIED":
            self = .denied
        case "ABORTED":
            self = .aborted
        case "ERROR":
            self = .error
        default:
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unknown verification status \(raw)"
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
    
}
