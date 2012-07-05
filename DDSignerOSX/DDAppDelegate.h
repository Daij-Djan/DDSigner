//
//  DDAppDelegate.h
//  DDSignerOSX
//
//  Created by Dominik Pich on 12.06.12.
//  Copyright (c) 2012 doo GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DDAppDelegate : NSObject <NSApplicationDelegate> 

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *decodedPathView;
//@property (assign) IBOutlet NSWindow *preferencesWindow;
//@property (retain) NSStatusItem *statusItem;
//@property (assign) IBOutlet NSMenu *statusItemMenu;

- (IBAction)openDocument:(id)sender;
- (IBAction)openSenders:(id)sender;
- (IBAction)openReceivers:(id)sender;

- (IBAction)signAndEncrypt:(id)sender;
- (IBAction)decryptAndVerify:(id)sender;

@property (nonatomic, copy) NSNumber *methodUsed;
@property (nonatomic, copy) NSString *documentPath;
@property (nonatomic, copy) NSString *sendersList;
@property (nonatomic, copy) NSString *receiversList;
@property (nonatomic, copy) NSString *encodeButtonTitle;

@property (readonly) NSString *encodedPath;
@property (readonly) NSString *decodedPath;
@property (readonly) NSAttributedString *logOutput;

@end
