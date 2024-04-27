//
//  JSONRPCClient+Invoke.swift
//  jsonrpc.framework
//
//  Created by Zadock Maloba on 27/04/2024.
//

import Foundation

extension JSONRPCClient {
    typealias RPCSuccessCallback = (RPCResponse) -> Void
    typealias RPCFailedCallback = (RPCError) -> Void
    
    @discardableResult
    func invoke(_ request: RPCRequest) -> String {
        postRequests(requests: [request], async: false)
        return request.id ?? ""
    }
    
    @discardableResult
    func invoke(_ method: String, params: Any?, onCompleted callback: RPCRequestCallback?) -> String {
        let request = RPCRequest()
        request.method = method
        request.params = params
        request.callback = callback
        return invoke(request)
    }
    
    @discardableResult
    func invoke(_ method: String, params: Any?, onSuccess successCallback: @escaping RPCSuccessCallback, onFailure failedCallback: @escaping RPCFailedCallback) -> String {
        return invoke(method, params: params) { response in
            if let error = response.error {
                failedCallback(error)
            } else {
                successCallback(response)
            }
        }
    }
}
