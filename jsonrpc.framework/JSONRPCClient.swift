//
//  JSONRPCClient.swift
//  jsonrpc.framework
//
//  Created by Zadock Maloba on 27/04/2024.
//

import Foundation

class JSONRPCClient: NSObject, NSURLConnectionDataDelegate, NSURLConnectionDelegate {
    var serviceEndpoint: String?
    var requests: NSMutableDictionary?
    var requestData: NSMutableDictionary?
    
    override init() {
        super.init()
        serviceEndpoint = nil
        requests = NSMutableDictionary()
        requestData = NSMutableDictionary()
    }
    
    convenience init(serviceEndpoint: String?) {
        self.init()
        self.serviceEndpoint = serviceEndpoint
    }
    
    func postRequest(request: RPCRequest, async: Bool) {
        postRequests(requests: [request], async: async)
    }
    
    func postRequests(requests: [RPCRequest], async: Bool) {
        let serializedRequests = requests.map { $0.serialize() }
        
        do {
            let payload = try JSONSerialization.data(withJSONObject: serializedRequests, options: [])
            
            guard let serviceEndpointURL = URL(string: serviceEndpoint!) else {
                // Handle the case where the service endpoint URL is invalid
                return
            }
            
            var serviceRequest = URLRequest(url: serviceEndpointURL)
            serviceRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceRequest.setValue("objc-JSONRpc/1.0", forHTTPHeaderField: "User-Agent")
            serviceRequest.httpMethod = "POST"
            serviceRequest.httpBody = payload
            
            if async {
                let task = URLSession.shared.dataTask(with: serviceRequest) { [weak self] (data, response, error) in
                    if let data = data {
                        self?.handleData(data: data, withRequests: requests)
                    } else {
                        // Handle the case where there's no data or an error occurred
                        // You can call handleFailedRequests here if needed
                    }
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
                
                semaphore.wait()
                
                if let data = responseData {
                    handleData(data: data, withRequests: requests)
                } else if responseError != nil {
                    // Handle the case where an error occurred
                    // You can call handleFailedRequests here if needed
                }
            }
        } catch {
            // Handle the case where JSON serialization fails
            // You can call handleFailedRequests here if needed
        }
    }
    
    func sendSynchronousRequest(request: RPCRequest) -> RPCResponse {
        let response = RPCResponse()
        
        do {
            let payload = try JSONSerialization.data(withJSONObject: request.serialize(), options: [])
            
            let serviceRequest = NSMutableURLRequest(url: URL(string: serviceEndpoint!)!)
            serviceRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceRequest.setValue("objc-JSONRpc/1.0", forHTTPHeaderField: "User-Agent")
            serviceRequest.setValue("\(payload.count)", forHTTPHeaderField: "Content-Length")
            serviceRequest.httpMethod = "POST"
            serviceRequest.httpBody = payload
            
            var serviceResponse: URLResponse?
            let data = try NSURLConnection.sendSynchronousRequest(serviceRequest as URLRequest, returning: &serviceResponse)
            
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: [])
            if let result = jsonResult as? [String: Any] {
                if let error = result["error"] as? [String: Any] {
                    response.error = RPCError.error(with: error)
                } else {
                    response.result = result["result"]
                }
                response.id = result["id"] as? String
                response.version = result["version"] as? String
            }
        } catch {
            response.error = RPCError.error(with: .parseError)
        }
        
        return response
    }
    
    // Implement NSURLConnectionDataDelegate and NSURLConnectionDelegate methods here
    
    func handleData(data: Data, withRequests requests: [RPCRequest]) {
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
