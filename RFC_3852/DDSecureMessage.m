    //
//  DDSecureMessage.m
//  DDSigner
//
//  Created by Dominik Pich on 12.06.12.
//  Copyright (c) 2012 Dominik Pich. All rights reserved.
//

#import "DDSecureMessage.h"

@implementation DDSecureMessage

+ (SecIdentityRef)identityForEmail:(NSString*)email {
    NSDictionary *dict = @{(id)kSecClass: (id)kSecClassIdentity, 
                          (id)kSecMatchEmailAddressIfPresent: email.lowercaseString,
                          (id)kSecReturnRef: @YES};
                          
    
    SecIdentityRef identity = nil;
    SecItemCopyMatching((__bridge CFDictionaryRef)dict, (CFTypeRef*)&identity);

    return identity;
}

+ (SecCertificateRef)certificateForEmail:(NSString*)email {
    NSDictionary *dict = @{(id)kSecClass: (id)kSecClassCertificate, 
                          (id)kSecMatchEmailAddressIfPresent: email.lowercaseString,
                          (id)kSecReturnRef: @YES};
    
    
    SecCertificateRef certificate = nil;
    SecItemCopyMatching((__bridge CFDictionaryRef)dict, (CFTypeRef*)&certificate);
    
    return certificate;    
}

+ (BOOL)messageVerifies:(DDSecureMessage*)msg {
    if(!msg.states.count ||
       msg.states.count!=msg.signers.count)
        return NO;
    
    for (NSNumber *state in msg.states) {
        if(state.integerValue != kCMSSignerValid)
            return NO;
    }
        
    return YES;
}

                                    
@synthesize signers;
@synthesize recipients;
@synthesize content;

@synthesize contentType;
@synthesize signedAttributes;
@synthesize states;

@end
