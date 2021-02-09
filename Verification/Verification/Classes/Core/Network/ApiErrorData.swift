//
//  ApiErrorData.swift
//  Verification
//
//  Created by Aleksander Wojcik on 17/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Class containing detailed information about what went wrong during the API call. (Server did not return 2xx status).
public struct ApiErrorData: Codable, Equatable {
    
    struct ErrorCodes {
        
        struct BadRequest {
            static let ParameterValidation = 40001
            static let  NumberMissingLeadingPlus = 40005
            static let InvalidRequest = 40003
            static let InvalidAuthorizationKey = 40004
        }
        
        struct Unauthorized {
            static let AuthorizationHeader = 40100
            static let TimestampHeader = 40101
            static let InvalidSignature = 40102
            static let AlreadyAuthorized = 40103
            static let AuthorizationRequired = 40104
            static let Expired = 40105
            static let UserBarred = 40106
            static let InvalidAuthorization = 40107
            static let InvalidCredentials = 40108
        }
        
        struct PaymentRequired {
            static let NotEnoughCredit = 40200
        }
        
        struct Forbidden {
            static let ForbiddenRequest = 40300
            static let InvalidScheme = 40301
            static let InsufficientPrivileges = 40302
            static let RestrictedAction = 40303
        }
        
        struct NotFound {
            static let ResourceNotFound = 40400
        }
        
        struct Conflict {
            static let RequestConflict = 40900
        }
        
        struct UnprocessableEntity {
            static let ApplicationConfiguration = 42200
            static let Unavailable = 42201
            static let InvalidCallbackResponse = 42202
        }
        
        struct TooManyRequests {
            static let CapacityExceeded = 42900
            static let VelocityConstraint = 42901
        }
        
        struct InternalServerError {
            static let InternalError = 50000
        }
        
        struct NotImplemented {
            static let MethodNotImplemented = 50100
            static let StatusNotImplemented = 50101
        }
        
        struct ServiceUnavailable {
            static let TemporaryDown = 50300
            static let ConfigurationError = 50301
        }
        
    }
    
    /// Integer defining specific error.
    let errorCode: Int?
    
    /// Human readable message describing why API call has failed
    let message: String?
    
    /// Optional reference id that was passed with the request.
    let reference: String?
    
    /// Flag indicating if error was probably caused my malformed phone number passed to request
    /// (too short, too long, wrong characters etc.). Note that this flag can return true even when the cause was actually
    /// different as the error code can be only be checked against 'ParameterValidation' error constant.
    var mightBePhoneFormattingError: Bool {
        get {
            return errorCode == ErrorCodes.BadRequest.ParameterValidation || errorCode == ErrorCodes.BadRequest.NumberMissingLeadingPlus
        }
    }
    
}
