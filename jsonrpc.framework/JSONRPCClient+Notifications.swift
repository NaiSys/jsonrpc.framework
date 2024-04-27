//
//  JSONRPCClient+Notifications.swift
//  jsonrpc.framework
//
//  Created by Zadock Maloba on 27/04/2024.
//

import Foundation

public extension JSONRPCClient {
    func notify(method: String, params: Any?) {
        let request = RPCRequest()
        request.method = method
        request.params = params
        request.id = nil // Id must be nil when sending notifications
        
        invoke(request)
    }
    
    func notify(method: String) {
        notify(method: method, params: nil)
    }
}
