//
//  DDAddressPicker.h
//  DDSigner
//
//  Created by Dominik Pich on 12.06.12.
//  Copyright (c) 2012 doo GmbH. All rights reserved.
//

#import <AddressBook/ABPeoplePickerView.h>


@interface DDAddressPicker : NSWindowController

@property (weak) IBOutlet ABPeoplePickerView *peoplePickerView;
@property (weak) IBOutlet NSButton *okButton;
@property (weak) IBOutlet NSButton *cancelButton;
- (IBAction)cancel:(id)sender;
- (IBAction)ok:(id)sender;

@property (readonly) NSArray *emails;
@end
