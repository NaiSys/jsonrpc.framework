//
//  RPCResponse.h
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 8/28/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <jsonrpc_framework/RPCError.h>

/**
 * RPC Resposne object
 *
 * This object is created when the server responds. 
 */
@interface RPCResponse : NSObject

/**
 * @brief The used RPC Version.
 *
 */
@property (nonatomic, retain) NSString *version;

/**
 * @brief The id that was used in the request.
 *
 */
@property (nonatomic, retain) NSString *id;

/**
 * @brief RPC Error. If != nil it means there was an error
 *
 */
@property (nonatomic, retain) RPCError *error;

/**
 * @brief An object represneting the result from the method on the server
 *
 */
@property (nonatomic, retain) id result;


#pragma mark - Methods

/**
 * Helper method to get an autoreleased RPCResponse object with an error set
 *
 * @param error RPCError The error for the response
 * @return RPCRequest
 */
+ (id) responseWithError:(RPCError*)error;

@end
