//
//  DDSecureMessage.h
//  DDSigner
//
//  Created by Dominik Pich on 12.06.12.
//  Copyright (c) 2012 Dominik Pich. All rights reserved.
//

#import <Security/Security.h>

#if TARGET_OS_IPHONE
/*
 * Standard signed attributes, optionally specified in 
 * CMSEncoderAddSignedAttributes().
 */
enum {
	kCMSAttrNone						= 0x0000,
    /* 
     * S/MIME Capabilities - identifies supported signature, encryption, and
     * digest algorithms.
     */
    kCMSAttrSmimeCapabilities			= 0x0001,
    /*
     * Indicates that a cert is the preferred cert for S/MIME encryption.
     */
    kCMSAttrSmimeEncryptionKeyPrefs		= 0x0002,
    /* 
     * Same as kCMSSmimeEncryptionKeyPrefs, using an attribute OID preferred
     * by Microsoft.
     */
    kCMSAttrSmimeMSEncryptionKeyPrefs	= 0x0004,
    /*
     * Include the signing time.
     */
    kCMSAttrSigningTime					= 0x0008
};
typedef uint32_t CMSSignedAttributes;
#endif

@interface DDSecureMessage : NSObject

+ (SecIdentityRef)identityForEmail:(NSString*)email;
+ (SecCertificateRef)certificateForEmail:(NSString*)email;
+ (BOOL)messageVerifies:(DDSecureMessage*)msg;

@property(retain) NSArray *signers; //signers for the content, NULL==no signatures (SecIdentityRef(s) for encoding SecCertificateRef(s) for verification)
@property(retain) NSArray *recipients; //recipients for which to encrypt, NULL==no encryption (SecCertificateRef(s))
@property(retain) NSData *content; //the raw data

@property(assign) CFDataRef *contentType; //if NULL, data-id is used ( the default ) -- but another OID can be set
@property(assign) CMSSignedAttributes signedAttributes; //determine what gets signed
@property(retain) NSArray *states; //the verification states of the individual signers
@end
