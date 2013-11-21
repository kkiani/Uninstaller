//
//  AppDelegate.m
//  Uninstaller
//
//  Created by Kiarash Kiani on 7/31/13.
//  Copyright (c) 2013 kiarash. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;
@synthesize File_TableView;
@synthesize ApplicationName;
@synthesize FileSize_Lable;
@synthesize FilePath_Lable;
@synthesize FileIcon_ImageView;
@synthesize Search_Field;

- (id)init
{
    self = [super init];
    if (self) {
        List = [[NSMutableArray alloc] init];
        TempList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [List count];
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification{
    //NSString *Path = [[[File_TableView viewAtColumn:0 row:[File_TableView selectedRow] makeIfNecessary:YES] FileNameField] stringValue];
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    ItemCell *cell = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
    [cell setFileName:[[List objectAtIndex:row] objectForKey:@"FileName"]];
    [cell setIcon:[[List objectAtIndex:row] objectForKey:@"Icon"]];
    [cell setDetails:[[List objectAtIndex:row] objectForKey:@"Size"]];
    
    return cell;
}

- (NSString *) bundleIdentifierForApplicationName:(NSString *)appName{
    NSWorkspace * workspace = [NSWorkspace sharedWorkspace];
    NSString * appPath = [workspace fullPathForApplication:appName];
    if (appPath) {
        NSBundle * appBundle = [NSBundle bundleWithPath:appPath];
        return [appBundle bundleIdentifier];
    }
    return nil;
}

- (NSArray *) searchForAppFiles:(NSString *)AppName BundleIdentifier:(NSString *)bundleIdentifier{
    NSMutableString *path = [[NSMutableString alloc] initWithString:NSHomeDirectory()];
    [path appendString:@"/Library"];
    
    NSArray *Files = [self GetListOfFiles:path];
    NSMutableArray *ListOfFiles = [[NSMutableArray alloc] init];
    
    for (NSString *EachFile in Files){
        if ([self containsString:EachFile substring:AppName]) {
            [ListOfFiles addObject:EachFile];
        }
    }
    
    return ListOfFiles;
}

- (NSArray *) GetListOfFiles:(NSString *)FolderURL{
    
    NSMutableArray *ListOfFiles = [[NSMutableArray alloc] init];
    NSMutableArray *ListOfFolders = [[NSMutableArray alloc] init];
    NSMutableArray *TempArray = [[NSMutableArray alloc] init];
    NSMutableString *path = [[NSMutableString alloc] init];
    
    
    TempArray = [[NSFileManager defaultManager] directoryContentsAtPath:FolderURL];
    for (NSString *file in TempArray){
        [path setString:file];
        //List of folders
        if ([[file pathExtension] isEqualToString:@""]){
            [ListOfFolders addObject:file];
        }
        //List of files
        if (![[file pathExtension] isEqualToString:@""]){
            NSString *url = FolderURL;
            url = [url stringByAppendingFormat:@"/%@" , file];
            [ListOfFiles addObject:url];
        }
    }
    
    if ([ListOfFolders count] != 0){
        for (NSString *EachFolder in ListOfFolders){
            NSString *path = FolderURL;
            path = [path stringByAppendingFormat:@"/"];
            path = [path stringByAppendingFormat:EachFolder];
            [ListOfFiles addObjectsFromArray:[self GetListOfFiles:path]];        }
        return ListOfFiles;
    }
    else{
        return ListOfFiles;
    }
}

- (BOOL) containsString:(NSString *)str substring:(NSString *)substring{
    NSRange range = [str rangeOfString: substring];
    BOOL found = ( range.location != NSNotFound );
    return found;
}

- (IBAction)ShowInFinder:(id)sender {
    //[NSApp orderFrontS];
    [[NSWorkspace sharedWorkspace] selectFile:[[[File_TableView viewAtColumn:0 row:[File_TableView selectedRow] makeIfNecessary:YES] FileNameField] stringValue] inFileViewerRootedAtPath:@""];
}

- (IBAction)OpenFile:(id)sender {
    NSOpenPanel *OpenApp = [NSOpenPanel openPanel];
    [OpenApp setCanChooseDirectories:NO];
    [OpenApp setCanCreateDirectories:NO];
    [OpenApp setCanChooseFiles:YES];
    [OpenApp setAllowsMultipleSelection:NO];
    [OpenApp setDirectoryURL:[NSURL URLWithString:@"file://localhost/Applications/"]];
    
    [OpenApp beginSheetModalForWindow:window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            [List removeAllObjects];
            
            NSString *FileName = [[[NSFileManager defaultManager] displayNameAtPath:[[OpenApp URL] absoluteString] ] stringByDeletingPathExtension];
            
            [ApplicationName setStringValue:FileName];
            [FilePath_Lable setStringValue:[[OpenApp URL] absoluteString]];
            [FileIcon_ImageView setImage:[[NSWorkspace sharedWorkspace] iconForFile:[OpenApp filename]]];
            
            NSMutableArray *Files =[[NSMutableArray alloc] initWithArray:[self searchForAppFiles:FileName BundleIdentifier:[self bundleIdentifierForApplicationName:FileName]]];
            [Files addObject:[[OpenApp URL] path]];
            
            float totalSize = 0;
            
            for (NSString *item in Files) {
                NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:item];
                float Size = (float)[[[NSFileManager defaultManager] attributesOfItemAtPath:item error:nil] fileSize] * 0.000976563;
                
                totalSize = Size + totalSize;
                
                NSString *size = [NSString stringWithFormat:@"s%f KB" , Size];
                NSDictionary *DItem = @{@"FileName" : item,
                @"Icon" : icon,
                @"Size" : size};
                
                [List addObject:DItem];
            }
            
            [FileSize_Lable setStringValue:[@"Total Size: " stringByAppendingFormat:@"%f KB" , totalSize]];
            
            [File_TableView reloadData];
        }
    }];
}

- (IBAction)Uninstall:(id)sender {
    NSAlert *UninstallAlert = [[NSAlert alloc] init];
    [UninstallAlert setMessageText:[@"Uninstalling " stringByAppendingString:[ApplicationName stringValue]]];
    [UninstallAlert setInformativeText:@"All Files will be remove completely, Are your sure to uninstall this application?"];
    [UninstallAlert setAlertStyle:NSWarningAlertStyle];
    [UninstallAlert addButtonWithTitle:@"Yes"];
    [UninstallAlert addButtonWithTitle:@"No"];
    [UninstallAlert beginSheetModalForWindow:window modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
    
    
}

- (IBAction)RemoveFromList:(id)sender {
    [List removeObjectAtIndex:[File_TableView selectedRow]];
    [File_TableView reloadData];
}

- (IBAction)Search:(id)sender {
    
    if ([[Search_Field stringValue] isEqualToString:@""]) {
        [File_TableView reloadData];
    }
    else{
        [TempList addObjectsFromArray:List];
        [List removeAllObjects];
        
        for (NSDictionary *item in TempList) {
            NSString *itemName = [item objectForKey:@"FileName"];
            if ([self containsString:itemName substring:[Search_Field stringValue]]) {
                [List addObject:item];
            }
        }
        [File_TableView reloadData];
        [List removeAllObjects];
        [List addObjectsFromArray:TempList];
        [TempList removeAllObjects];
    }
    
}

- (void) alertDidEnd:(NSAlert *) alert returnCode:(int) returnCode contextInfo:(int *) contextInfo
{
    if (returnCode == 1000) {
        for (NSDictionary *item in List) {
            [[NSFileManager defaultManager] removeItemAtPath:[item objectForKey:@"FileName"] error:nil];
        }
        [List removeAllObjects];
        [File_TableView reloadData];
    }
}
@end
