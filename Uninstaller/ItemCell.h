//
//  ItemCell.h
//  Uninstaller
//
//  Created by Kiarash Kiani on 7/31/13.
//  Copyright (c) 2013 kiarash. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ItemCell : NSTableCellView

@property (weak) IBOutlet NSTextField *FileNameField;
@property (weak) IBOutlet NSTextField *DetailsField;
@property (weak) IBOutlet NSImageView *IconField;

- (void)setFileName:(NSString *)name;
- (void)setDetails:(NSString *)Details;
- (void)setIcon:(NSImage *)Icon;

@end
