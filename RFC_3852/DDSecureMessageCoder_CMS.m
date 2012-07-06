//
//  DDSecureMessageStore.m
//  DDSigner
//
//  Created by Dominik Pich on 12.06.12.
//  Copyright (c) 2012 Dominik Pich. All rights reserved.
//

#import "DDSecureMessageCoder.h"
#import "DDSecureMessage.h"

@implementation DDSecureMessageCoder (CMS)

+ (NSData*)cms_encodedDataFromMessage:(DDSecureMessage*)message error:(NSError**)pError {
    CFDataRef data = nil;
    
    CMSEncodeContent((__bridge CFArrayRef)message.signers,
              (__bridge CFArrayRef)message.recipients, 
              message.contentType, 
              NO,
              message.signedAttributes, 
              message.content.bytes, 
              message.content.length,
              &data);
    
    return (__bridge_transfer NSData*)data;
}

+ (DDSecureMessage*)cms_decodedMessageFromData:(NSData*)data error:(NSError**)pError {
    CMSDecoderRef ref = nil;
    CMSDecoderCreate(&ref);
    CMSDecoderUpdateMessage(ref, data.bytes, data.length);
    CMSDecoderFinalizeMessage(ref);

    DDSecureMessage *msg = [[DDSecureMessage alloc] init];
    
    size_t numberOfSigners = 0;
    CMSDecoderGetNumSigners(ref, &numberOfSigners);    
    NSMutableArray *signers = [NSMutableArray arrayWithCapacity:numberOfSigners];
    NSMutableArray *states = [NSMutableArray arrayWithCapacity:numberOfSigners];
    for (size_t i = 0; i<numberOfSigners; i++) {
        SecCertificateRef cert = nil;
        CMSDecoderCopySignerCert(ref, i, &cert);
        if(cert) {
            [signers addObject:(__bridge id)cert];
        }

        CMSSignerStatus status; 
        CMSDecoderCopySignerStatus(ref, i, SecPolicyCreateBasicX509(), TRUE, &status, NULL, NULL);
        [states addObject:[NSNumber numberWithInteger:status]];
    }
    msg.signers = signers;
    msg.states = states;

    CFDataRef dataRef = nil;
    CMSDecoderCopyContent(ref, &dataRef);
    msg.content = (__bridge_transfer NSData*)dataRef;

    return msg;
}

@end
