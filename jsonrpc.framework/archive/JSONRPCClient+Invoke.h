//
//  JSONRPCClient+Invoke.h
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 9/16/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import <jsonrpc_framework/JSONRPCClient.h>

// Few other callback types (default RPCCompletedCallback is defined inside BaseRPCClient.h)
typedef void (^RPCSuccessCallback)(RPCResponse *response);
typedef void (^RPCFailedCallback)(RPCError *error);

/**
 * Invoking
 *
 * - Adds invoking of methods on the remote server through the jsonrpcclient class
 */
@interface JSONRPCClient (Invoke)

/**
 * Invokes a RPCRequest against the end point.
 *
 * @param  request RPCRequest The request to invoke
 * @return NSString The used request id. Can be used to match callback's if neccesary
 */
- (NSString *) invoke:(RPCRequest*) request;

/**
 * Invokes a method against the end point. This method actually generates an RPCRequest object and calls invoke:request
 *
 * @param method NSString The method to invoke
 * @param params id Either named or un-named parameter list (or nil)
 * @param callback RPCCompletedCallback A callback method to invoke when request is done (or any error accours)
 * @return NSString The used request id. Can be used to match callback's if neccesary
 */
- (NSString *) invoke:(NSString*) method params:(id) params  onCompleted:(RPCRequestCallback)callback;

/**
 * Invokes a method against endpoint providing a way to define both a success callback and a failure callback.
 *
 * This method simply wraps invoke:method:params:onCompleted
 * 
 * @param method NSString The method to invoke
 * @param params id Either named or un-named parameter list (or nil)
 * @param successCallback RPCSuccessCallback A callback method to invoke when request finishes successfull
 * @param failedCallback RPCFailedCallback A callback method to invoke when request finishes with an error
 * @return NSString The used request id. Can be used to match callback's if neccesary
 */
- (NSString *) invoke:(NSString*) method params:(id) params onSuccess:(RPCSuccessCallback)successCallback onFailure:(RPCFailedCallback)failedCallback;

@end
