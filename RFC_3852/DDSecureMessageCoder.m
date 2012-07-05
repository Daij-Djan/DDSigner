//
//  DDSecureMessageStore.m
//  DDSigner
//
//  Created by Dominik Pich on 12.06.12.
//  Copyright (c) 2012 doo GmbH. All rights reserved.
//

#import "DDSecureMessageCoder_CMS.h"
#import "DDSecureMessage.h"

@implementation DDSecureMessageCoder

+ (NSData*)encodedDataFromMessage:(DDSecureMessage*)message error:(NSError**)pError {
#if TARGET_OS_IPHONE
    @throw [NSException exceptionWithName:@"IOS" reason:@"NO CMS API" userInfo:nil];
    return nil;
#else
    return [self cms_encodedDataFromMessage:message error:pError];
#endif
    return nil;
}

+ (DDSecureMessage*)decodedMessageFromData:(NSData*)data error:(NSError**)pError {
#if TARGET_OS_IPHONE
    @throw [NSException exceptionWithName:@"IOS" reason:@"NO CMS API" userInfo:nil];
    return nil;
#else
    return [self cms_decodedMessageFromData:data error:pError];
#endif
}

@end
