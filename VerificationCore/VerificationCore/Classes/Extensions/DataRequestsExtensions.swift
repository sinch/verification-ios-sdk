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
    
    public func sinchInitiationResponse<Data>(_ callback: InitiationApiCallback<Data>) {
        sinchResponse(resultCallback: callback.handleResponse)
    }
    
    public func sinchValidationResponse(_ callback: VerificationApiCallback) {
        sinchValidationResponse(resultCallback: callback.handleResponse)
    }
    
    internal func sinchValidationResponse(resultCallback: @escaping (_ response: ApiResponse<VerificationResponseData>) -> Void) {
        self.sinchResponse { (result: ApiResponse<VerificationResponseData>) in
            switch result {
            case .success(let data, _) where data.status == .successful:
                resultCallback(result)
            case .success(let data, _) where data.status == .error:
                let error = data.asSDKError ?? SDKError.unexpected(message: "Unexpected error occured")
                resultCallback(.failure(error))
            case .success(let data, _):
                resultCallback(.failure(SDKError.unexpected(message: "Verification request returned status \(data.status)")))
            case .failure:
                resultCallback(result)
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
