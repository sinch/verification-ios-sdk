//
//  VerificationError.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 13/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

public enum VerificationError: Error {
    case illegalArgument(message: String?)
    case serialization(encodable: Encodable)
    case apiCall(data: ApiErrorData)
    case unexpected(message: String?)
}
