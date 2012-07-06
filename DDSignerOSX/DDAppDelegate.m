//
//  DDAppDelegate.m
//  DDSignerOSX
//
//  Created by Dominik Pich on 12.06.12.
//  Copyright (c) 2012 Dominik Pich. All rights reserved.
//

#import "DDAppDelegate.h"
#import "DDAddressPicker.h"
#import <AddressBook/ABPerson.h>

#import "DDSecureMessageCoder.h"
//#import "DDPDFSigner.h"

@interface DDAppDelegate ()
@property (readwrite) NSString *encodedPath;
@property (readwrite) NSString *decodedPath;
@property (readwrite) NSAttributedString *logOutput;
@end

@implementation DDAppDelegate

#pragma mark -

- (void)awakeFromNib {
    self.encodeButtonTitle = _methodUsed.integerValue ? @"sign" : @"sign & encrypt";
}

#pragma mark -

- (IBAction)openDocument:(id)sender {
    //@throw [NSException exceptionWithName:@"na" reason:@"none" userInfo:nil];
//    DDAppDelegate *s = nil;
//    NSLog(@"%@",s->_decodedPath);
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseFiles = YES;
    openPanel.canChooseDirectories = NO;
    if([openPanel runModal] == NSAlertDefaultReturn) {
        self.documentPath = [(openPanel.URLs)[0] path];
    }    
}
- (IBAction)openSenders:(id)sender {
    DDAddressPicker *picker = [[DDAddressPicker alloc] initWithWindowNibName:@"DDAddressPicker"];
    if([NSApp runModalForWindow:picker.window] == NSAlertDefaultReturn) {
        for(id value in picker.emails) {
            if(!self.sendersList.length) {
                self.sendersList = value;
            }
            else {
                self.sendersList = [self.sendersList stringByAppendingFormat:@", %@", value];
            }
        }
    }
}
- (IBAction)openReceivers:(id)sender {
    DDAddressPicker *picker = [[DDAddressPicker alloc] initWithWindowNibName:@"DDAddressPicker"];
    if([NSApp runModalForWindow:picker.window] == NSAlertDefaultReturn) {
        for(id value in picker.emails) {
            if(!self.receiversList.length) {
                self.receiversList = value;
            }
            else {
                self.receiversList = [self.receiversList stringByAppendingFormat:@", %@", value];
            }
        }
    }
}

#pragma mark -

- (IBAction)signAndEncrypt:(id)sender {
    self.encodedPath = nil;
    
    if(self.documentPath.length && [[NSFileManager defaultManager] fileExistsAtPath:self.documentPath]) {
        NSData *data = [NSData dataWithContentsOfFile:self.documentPath];
        NSError *error = nil;
//        NSData *encodedData = _methodUsed.integerValue ? [self encodeRFC3852:data error:&error] : [DDPDFSigner signedPdfDataFromPdfData:data error:&error];
        NSData *encodedData = [self encodeRFC3852:data error:&error];
        if(encodedData) {
            NSString *p = [[NSHomeDirectory() stringByAppendingPathComponent:[self.documentPath lastPathComponent]] stringByAppendingPathExtension:@"DDSigner_Output"];
            
            [encodedData writeToFile:p atomically:NO];
          
            [self appendToLog:@"Wrote signed and encrypted file"];

            self.encodedPath = p;
        }
        else {
            [self appendToLog:@"Failed to sign and encrypt file"];
            [self appendToLog:error];
        }
    }
    else {
        [self appendToLog:@"Document not found at path"];        
    }
}
- (IBAction)decryptAndVerify:(id)sender {
    self.decodedPath = nil;
    self.decodedPathView.backgroundColor = [NSColor redColor];

    if(self.documentPath.length && [[NSFileManager defaultManager] fileExistsAtPath:self.documentPath]) {
        NSData *data = [NSData dataWithContentsOfFile:self.documentPath];
        BOOL verified = NO;
        NSError *error = nil;
//        NSData *decodedData = _methodUsed.integerValue ? [self decodeRFC3852:data verified:&verified error:&error] : [DDPDFSigner pdfDataFromSignedPdfData:data verified:&verified error:&error];
        NSData *decodedData = [self decodeRFC3852:data verified:&verified error:&error];
        
        if(decodedData) {
            NSString *p = [[NSHomeDirectory() stringByAppendingPathComponent:[self.documentPath lastPathComponent]] stringByDeletingPathExtension];
            
            [decodedData writeToFile:p atomically:NO];
            
            [self appendToLog:@"Wrote decrypted file"];
            
            self.decodedPath = p;
        }
        else {
            [self appendToLog:@"Failed to decrypt and verify file"];
            [self appendToLog:error];
        }
        self.decodedPathView.backgroundColor = verified ? [NSColor greenColor] : [NSColor redColor];
    }
    else {
        [self appendToLog:@"Document not found at path"];        
    }
}

#pragma mark -

- (void)setMethodUsed:(NSNumber *)methodUsed {
    _methodUsed = methodUsed;
    self.encodeButtonTitle = _methodUsed.integerValue ? @"sign" : @"sign & encrypt";
}
- (void)setDocumentPath:(NSString *)dPath {
    if(![dPath isEqualToString:_documentPath]) {
        _documentPath = [dPath copy];
        
        self.encodedPath = nil;
        self.decodedPath = nil;
    }
    
}
-(void)setSendersList:(NSString *)kPath  {
    if(![kPath isEqualToString:_sendersList]) {
        _sendersList = [kPath copy];
        
        self.encodedPath = nil;
        self.decodedPath = nil;
    }
    
}
- (void)setReceiversList:(NSString *)kPath {
    if(![kPath isEqualToString:_receiversList]) {
        _receiversList = [kPath copy];
        
        self.encodedPath = nil;
        self.decodedPath = nil;
    }
    
}

- (void)appendToLog:(id)output {
    if(!output) return;
    
    NSString *s = [[output description] stringByAppendingString:@"\n"];
    
    if(!_logOutput)
        self.logOutput = [[NSAttributedString alloc] initWithString:s];
    else {
        id copy = self.logOutput.mutableCopy;
        [copy appendAttributedString:[[NSAttributedString alloc] initWithString:s]];
        self.logOutput = copy;
    }
}

#ifdef DEBUG

#pragma mark - Test All

- (id)test:(id)file senders:(id)senders receivers:(id)receivers succeed:(BOOL)succeed {
    self.documentPath = file;
    self.sendersList = senders;
    self.receiversList = receivers;
    [self signAndEncrypt:nil];

    if(!succeed) {
        self.sendersList = nil;
        self.receiversList = nil;    
    }
    
    self.documentPath = self.encodedPath;
    [self decryptAndVerify:nil];
    
    return self.decodedPath;
}

- (void)testAll {
    [self appendToLog:@"Test encrypt -> decrypt"];
    
    //encrypt & sign -> and back
    NSString *res1 = [self test:[[NSBundle mainBundle] pathForResource:@"testmsg" ofType:@"txt"] senders:@"Dominik@pich.info" receivers:@"Daij-Djan@macbay.de" succeed:YES];
    NSData *d1 = [NSData dataWithContentsOfFile:res1];
    [[NSFileManager defaultManager] moveItemAtPath:res1 toPath:[res1 stringByAppendingPathExtension:@"1"] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:self.encodedPath error:nil];
    
    //encrypt & dont sign -> and back
    NSString *res2 = [self test:[[NSBundle mainBundle] pathForResource:@"testmsg" ofType:@"txt"] senders:nil receivers:@"Daij-Djan@macbay.de" succeed:YES];
    NSData *d2 = [NSData dataWithContentsOfFile:res2];
    [[NSFileManager defaultManager] moveItemAtPath:res1 toPath:[res1 stringByAppendingPathExtension:@"2"] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:self.encodedPath error:nil];

    //dont encrypt & sign -> and back
    NSString *res3 = [self test:[[NSBundle mainBundle] pathForResource:@"testmsg" ofType:@"txt"] senders:@"Dominik@pich.info" receivers:@"Daij-Djan@macbay.de" succeed:YES];
    NSData *d3 = [NSData dataWithContentsOfFile:res3];
    [[NSFileManager defaultManager] moveItemAtPath:res1 toPath:[res1 stringByAppendingPathExtension:@"3"] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:self.encodedPath error:nil];        

    if(![d1 isEqualToData:d2] || ![d2 isEqualToData:d3]) {
        NSLog(@"TESTS FAILED");
        [NSApp terminate:nil];
    }
    
    //tests that SHOULD fail

    //encrypt & sign -> and back
    res1 = [self test:[[NSBundle mainBundle] pathForResource:@"testmsg" ofType:@"txt"] senders:@"Dominik@pich.info" receivers:@"Daij-Djan@macbay.de" succeed:NO];
    
    //encrypt & dont sign -> and back
    res2 = [self test:[[NSBundle mainBundle] pathForResource:@"testmsg" ofType:@"txt"] senders:nil receivers:@"Daij-Djan@macbay.de" succeed:NO];
    
    //dont encrypt & sign -> and back
    res3 = [self test:[[NSBundle mainBundle] pathForResource:@"testmsg" ofType:@"txt"] senders:@"Dominik@pich.info" receivers:@"Daij-Djan@macbay.de" succeed:NO];
    
    if(res1.length || res2.length || res3.length) {
        NSLog(@"TESTS FAILED");
        [NSApp terminate:nil];
    }
}
       
#endif

#pragma mark - RFC3258

- (NSArray*)identitiesFromSendersList {
    NSArray *emails = [self.sendersList componentsSeparatedByString:@", "];
    NSMutableArray *identities = [NSMutableArray arrayWithCapacity:emails.count]; 
    for (NSString *email in emails) {
        id identity = (__bridge id)[DDSecureMessage identityForEmail:email];
        if(identity) {
            [identities addObject:identity];
        }
    }
    return identities;
}
- (NSArray*)certificatesFromReceiversList {
    NSArray *emails = [self.sendersList componentsSeparatedByString:@", "];
    NSMutableArray *certificates = [NSMutableArray arrayWithCapacity:emails.count]; 
    for (NSString *email in emails) {
        id cert = (__bridge id)[DDSecureMessage certificateForEmail:email];
        if(cert) {
            [certificates addObject:cert];
        }
    }
    return certificates;
}
- (NSData*)encodeRFC3852:(NSData*)data error:(NSError**)perror {
    DDSecureMessage *msg = [[DDSecureMessage alloc] init];
    msg.signers = self.identitiesFromSendersList;
    msg.recipients = self.certificatesFromReceiversList;
    msg.content = data;
    
    return [DDSecureMessageCoder encodedDataFromMessage:msg error:perror];
}
- (NSData*)decodeRFC3852:(NSData*)data verified:(BOOL*)pverified error:(NSError**)perror {
    DDSecureMessage *msg = [DDSecureMessageCoder decodedMessageFromData:data error:perror];
    if(pverified) {
        *pverified = [DDSecureMessage messageVerifies:msg];
    }
    return msg.content;
}

#pragma mark - d&d
//- (void)applicationDidFinishLaunching:(NSNotification *)notification {
//    NSStatusItem *item = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
//}

@end
