//
//  DDAddressPicker.m
//  DDSigner
//
//  Created by Dominik Pich on 12.06.12.
//  Copyright (c) 2012 doo GmbH. All rights reserved.
//

#import "DDAddressPicker.h"

@implementation DDAddressPicker
@synthesize peoplePickerView;
@synthesize okButton;
@synthesize cancelButton;

- (IBAction)cancel:(id)sender {
    [peoplePickerView deselectAll:nil];
    [NSApp stopModalWithCode:NSAlertErrorReturn];
}

- (IBAction)ok:(id)sender {
    if(!self.emails.count) return;
    [NSApp stopModalWithCode:NSAlertDefaultReturn];
}

- (NSArray *)emails {
    return peoplePickerView.selectedValues.count ? peoplePickerView.selectedValues : nil;
}

@end
