//
//  ApiErrorData.swift
//  Verification
//
//  Created by Aleksander Wojcik on 17/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Class containing detailed information about what went wrong during the API call. (Server did not return 2xx status).
public struct ApiErrorData: Decodable {
    
    /// Integer defining specific error.
    let errorCode: Int?
    
    /// Human readable message describing why API call has failed
    let message: String?
    
    /// Optional reference id that was passed with the request.
    let reference: String?
    
}
