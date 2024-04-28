//
//  JSONRPCClient.swift
//  jsonrpc.framework
//
//  Created by Zadock Maloba on 27/04/2024.
//

import Foundation

public class JSONRPCClient: NSObject, NSURLConnectionDataDelegate, NSURLConnectionDelegate {
    var serviceEndpoint: String?
    var requests: NSMutableDictionary?
    var requestData: NSMutableDictionary?
    
    override init() {
        super.init()
        serviceEndpoint = nil
        requests = NSMutableDictionary()
        requestData = NSMutableDictionary()
    }
    
    public convenience init(serviceEndpoint: String?) {
        self.init()
        self.serviceEndpoint = serviceEndpoint
    }
    
    func postRequest(request: RPCRequest, async: Bool) {
        postRequests(requests: [request], async: async)
    }
    
    func postRequests(requests: [RPCRequest], async: Bool) {
        //let serializedRequests = requests.map { $0.serialize() }
        
        for req in requests {
            let serializedReq = req.serialize()
            
            do {
                let payload = try JSONSerialization.data(withJSONObject: serializedReq, options: [])
                
                guard let serviceEndpointURL = URL(string: serviceEndpoint!) else {
                    // Handle the case where the service endpoint URL is invalid
                    NSLog("Warning: Invalid URL")
                    return
                }
                
                var serviceRequest = URLRequest(url: serviceEndpointURL)
                serviceRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                serviceRequest.setValue("objc-JSONRpc/1.0", forHTTPHeaderField: "User-Agent")
                serviceRequest.setValue("\(payload.count)", forHTTPHeaderField: "Content-Length")
                serviceRequest.httpMethod = "POST"
                serviceRequest.httpBody = payload
                
                if let payload_string = String(data: payload, encoding: .utf8) {
                    NSLog(payload_string)
                }
                
                if async {
                    let task = URLSession.shared.dataTask(with: serviceRequest) { [weak self] (data, response, error) in
                        NSLog("Handling async request")
                        guard let data = data, error == nil else {
                            NSLog("Warning: Network Error")
                            self?.handleFailedRequests(requests: requests, withRPCError: RPCError(code: .networkError))
                            return
                        }
                        
                        self?.handleData(data: data, withRequests: requests)
                    }
                    task.resume()
                } else {
                    let semaphore = DispatchSemaphore(value: 0)
                    var responseData: Data?
                    var responseError: Error?
                    
                    let task = URLSession.shared.dataTask(with: serviceRequest) { (data, response, error) in
                        responseData = data
                        responseError = error
                        semaphore.signal()
                    }
                    task.resume()
                    
                    NSLog("Synchronous: Awaiting response")
                    semaphore.wait()
                    
                    if let data = responseData {
                        handleData(data: data, withRequests: requests)
                    } else if responseError != nil {
                        NSLog("Warning: Network Error")
                        self.handleFailedRequests(requests: requests, withRPCError: RPCError(code: .networkError))
                        
                    }
                    //self.sendSynchronousRequest(request: serviceRequest)
                }
            } catch {
                // Handle the case where JSON serialization fails
                // You can call handleFailedRequests here if needed
                NSLog("JSON serialization failed")
                handleFailedRequests(requests: requests, withRPCError: RPCError(code: .parseError))
            }
        }
    }
    
    func handleData(data: Data, withRequests requests: [RPCRequest]) {
        NSLog("Received response, handling data")
        do {
            let results = try JSONSerialization.jsonObject(with: data, options: [])
            
            if let resultsDict = results as? [String: Any] {
                for request in requests {
                    if let callback = request.callback {
                        if data.isEmpty {
                            callback(RPCResponse.responseWithError(error: RPCError.error(with: .serverError)))
                        } else {
                            if let error = resultsDict["error"] as? [String: Any] {
                                callback(RPCResponse.responseWithError(error: RPCError.error(with: error) ?? RPCError()))
                            } else {
                                callback(RPCResponse(result: resultsDict["result"], id: resultsDict["id"] as? String, version: resultsDict["version"] as? String))
                            }
                        }
                    }
                }
            } else if let resultsArray = results as? [[String: Any]] {
                for result in resultsArray {
                    for request in requests {
                        if let callback = request.callback {
                            if let requestId = result["id"] as? String, requestId == request.id {
                                if let error = result["error"] as? [String: Any] {
                                    callback(RPCResponse.responseWithError(error: RPCError.error(with: error) ?? RPCError()))
                                } else {
                                    callback(RPCResponse(result: result["result"], id: result["id"] as? String, version: result["version"] as? String))
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            handleFailedRequests(requests: requests, withRPCError: RPCError.error(with: .parseError))
        }
    }
    
    func handleFailedRequests(requests: [RPCRequest], withRPCError error: RPCError) {
        for request in requests {
            if let callback = request.callback {
                callback(RPCResponse.responseWithError(error: error))
            }
        }
    }
    
    // Implement other methods and delegate callbacks as needed
}
