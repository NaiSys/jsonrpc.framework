//
//  JSONRPCClient+Multicall.swift
//  jsonrpc.framework
//
//  Created by Zadock Maloba on 27/04/2024.
//

import Foundation

extension JSONRPCClient {
    func batch(_ request: RPCRequest, _ others: RPCRequest...) {
        var tmpRequests = [RPCRequest]()
        
        tmpRequests.append(request)
        tmpRequests.append(contentsOf: others)
        
        if !tmpRequests.isEmpty {
            postRequests(requests: tmpRequests, async: true)
        }
    }
}
