//
//  AppDelegate.h
//  Uninstaller
//
//  Created by Kiarash Kiani on 7/31/13.
//  Copyright (c) 2013 kiarash. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ItemCell.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate>{
    NSMutableArray *List;
    NSMutableArray *TempList;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTableView *File_TableView;
@property (weak) IBOutlet NSTextField *ApplicationName;
@property (weak) IBOutlet NSTextField *FileSize_Lable;
@property (weak) IBOutlet NSTextField *FilePath_Lable;
@property (weak) IBOutlet NSImageView *FileIcon_ImageView;
@property (weak) IBOutlet NSSearchField *Search_Field;

- (IBAction)ShowInFinder:(id)sender;
- (IBAction)OpenFile:(id)sender;
- (IBAction)Uninstall:(id)sender;
- (IBAction)RemoveFromList:(id)sender;
- (IBAction)Search:(id)sender;


@end
