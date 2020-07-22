//
//  DataRequestsExtensions.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 17/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import Foundation
import Alamofire

extension DataRequest {
    
    public func sinchResponse<T: Decodable> (resultCallback: @escaping (_ response: ApiResponse<T>) -> Void) {
        self.validate().responseData { dataResponse in
            guard let responseData = dataResponse.data else {
                let passedError: Error = dataResponse.error ?? SDKError.unexpected(message: "API response is nil and no error present")
                resultCallback(.failure(passedError))
                return
            }
            if dataResponse.error != nil {
                resultCallback(.failure(decodeErrorData(responseData)))
            } else {
                handleSuccessfullResponse(responseData,
                                          headers: dataResponse.request?.headers.dictionary ?? [:],
                                          resultCallback: resultCallback)
            }
        }
    }
}

fileprivate func decodeErrorData(_ data: Data) -> Error {
    do {
        let decodedError = try ApiErrorData.make(from: data)
        return SDKError.apiCall(data: decodedError)
    } catch {
        return error
    }
}

fileprivate func handleSuccessfullResponse<T: Decodable>(
    _ data: Data,
    headers: ResponseHeaders,
    resultCallback: @escaping (_ response: ApiResponse<T>) -> Void) {
    do {
        let decodedResponse = try T.make(from: data)
        resultCallback(.success(decodedResponse, headers))
    } catch {
        resultCallback(.failure(error))
    }
}
