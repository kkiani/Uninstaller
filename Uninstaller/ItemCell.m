//
//  ItemCell.m
//  Uninstaller
//
//  Created by Kiarash Kiani on 7/31/13.
//  Copyright (c) 2013 kiarash. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell

@synthesize FileNameField;
@synthesize DetailsField;
@synthesize IconField;

- (void)setFileName:(NSString *)name{
    [FileNameField setStringValue:name];
}

- (void)setDetails:(NSString *)Details{
    [DetailsField setStringValue:Details];
}

- (void)setIcon:(NSImage *)Icon{
    [IconField setImage:Icon];
}

@end
