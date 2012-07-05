//
//  DDSecureMessageStore.h
//  DDSigner
//
//  Created by Dominik Pich on 12.06.12.
//  Copyright (c) 2012 doo GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSecureMessage.h"

@interface DDSecureMessageCoder : NSObject

+ (NSData*)encodedDataFromMessage:(DDSecureMessage*)message error:(NSError**)pError;
+ (DDSecureMessage*)decodedMessageFromData:(NSData*)data error:(NSError**)pError;

@end
