#import "AppDelegate.h"

@implementation AppDelegate

@synthesize aboutPanel = _aboutPanel;
@synthesize directoryTextfield = _directoryTextfield;
@synthesize scriptTextfield = _scriptTextfield;
@synthesize configurationsController = _configurationsController;
@synthesize window = _window;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize managedObjectContext = __managedObjectContext;

- (BOOL) applicationShouldOpenUntitledFile:(NSApplication *)sender
{
  [_window makeKeyAndOrderFront:self];
  return NO;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  _running = [[NSMutableArray alloc] init];
  
  FolderNameTransformer * folderNameTransformer = [[FolderNameTransformer alloc] init];
  [NSValueTransformer setValueTransformer:folderNameTransformer
                                  forName:@"FolderNameTransformer"];  
  
  FolderCellTransformer * folderCellTransformer = [[FolderCellTransformer alloc] init];
  [NSValueTransformer setValueTransformer:folderCellTransformer
                                  forName:@"FolderCellTransformer"];  
  
  
  FSEventDispatcher * events;
  events = [[FSEventDispatcher alloc] init];
  
  [events start];
  
  [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(fsEventNotification:) 
                                               name:@"FSFileInPathChangedNotification" 
                                             object:nil];
  
  NSSortDescriptor * sd = [[NSSortDescriptor alloc] initWithKey:@"folder" ascending:YES]; 
  [_configurationsController setSortDescriptors:[NSArray arrayWithObject:sd]];

}

#pragma mark -
#pragma mark Events

- (void)fsEventNotification:(NSNotification *)notification
{
  NSString * changedPath = [[notification userInfo] objectForKey:@"path"];
  NSDate * changedTime = [[notification userInfo] objectForKey:@"time"];
  
  NSArray * configurations = [[self configurationsController] arrangedObjects];
  NSInteger count = [configurations count];
  int i;
  
  for(i = 0; i < count; i++)
  {
    NSManagedObject * obj = [configurations objectAtIndex:i];
    NSString * watchedFolder = [obj valueForKey:@"folder"];
    
    if(watchedFolder == nil) continue;
    if([watchedFolder isEqualToString:@""]) continue;
    
    NSRange textRange = [changedPath rangeOfString:watchedFolder];
    
    /* Location Match */
    if(textRange.location != NSNotFound)
    {
      /* Enabled Config */
      if([[obj valueForKey:@"enabled"] boolValue])
      {
        /* Not Running */
        if([_running indexOfObject:obj.objectID.URIRepresentation.path] == NSNotFound)
        {
          ActionProperties * props = [[ActionProperties alloc] init];
          props.folder = [obj valueForKey:@"folder"];
          props.match = [obj valueForKey:@"match"];
          props.script = [obj valueForKey:@"script"];
          props.enabled = [[obj valueForKey:@"enabled"] boolValue];
          props.safari = [[obj valueForKey:@"safari"] boolValue];
          props.chrome = [[obj valueForKey:@"chrome"] boolValue];
          props.datetime = [changedTime description];
          props.count = [[obj valueForKey:@"count"] intValue];
          props.pathId = obj.objectID.URIRepresentation.path;

          [_running addObject:obj.objectID.URIRepresentation.path];
          
          Action * action = [[Action alloc] initWithProperties:props];

          [[NSNotificationCenter defaultCenter] addObserver:self
                                                   selector:@selector(actionCompleted:)
                                                       name:@"actionCompleted"
                                                     object:nil];
            
          [action execute];
            
          NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
          [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
          [obj setValue:[dateFormat stringFromDate:[NSDate date]] forKey:@"lastAction"];
          [obj setValue:[NSNumber numberWithInt:props.count+1] forKey:@"count"];          
        }
      }
    }
  }
}

-(void)actionCompleted:(NSNotification *)notification
{
  ActionProperties * properties = (ActionProperties *)[[notification userInfo] objectForKey:@"properties"];
  [_running removeObject:properties.pathId];
}

#pragma mark -
#pragma mark Interface Actions

- (IBAction)clickSelectMonitorDirectory:(id)sender
{
  NSOpenPanel* openDlg = [NSOpenPanel openPanel];
  [openDlg setCanChooseFiles:NO];
  [openDlg setCanChooseDirectories:YES];
  [openDlg setAllowsMultipleSelection: NO];
  [openDlg setTitle:@"Choose folder to watch"];
  [openDlg setDirectoryURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",[_directoryTextfield stringValue]]]];
  if([openDlg runModal] == NSFileHandlingPanelOKButton)
  {
    NSURL * dir = [openDlg URL];
    NSManagedObject * o = [[[self configurationsController] selectedObjects] objectAtIndex:0];
    [o setValue:[dir path] forKey:@"folder"];
  }
}

- (IBAction)clickSelectScriptFile:(id)sender 
{
  NSOpenPanel* openDlg = [NSOpenPanel openPanel];
  [openDlg setCanChooseFiles:YES];
  [openDlg setCanChooseDirectories:NO];
  [openDlg setAllowsMultipleSelection: NO];
  [openDlg setTitle:@"Choose shell script"];
  [openDlg setDirectoryURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",[_scriptTextfield stringValue]]]];
  
  NSArray *tarr = [NSArray arrayWithObjects:@"sh", nil];
  [openDlg setAllowedFileTypes:tarr];
  
  if([openDlg runModal] == NSFileHandlingPanelOKButton)
  {
    NSURL * dir = [openDlg URL];
    NSManagedObject * o = [[[self configurationsController] selectedObjects] objectAtIndex:0];
    [o setValue:[dir path] forKey:@"script"];
  }
}

- (IBAction)clickAbout:(id)sender
{
  [_aboutPanel makeKeyAndOrderFront:nil];
}

- (IBAction)clickVisit:(id)sender
{
  NSURL * someUrl = [NSURL URLWithString:@"http://penck.de/browserreload/"];
  [[NSWorkspace sharedWorkspace] openURL:someUrl];
}

- (IBAction)clickCloseWindow:(id)sender
{
  [_window close];
}

- (IBAction)clickHelp:(id)sender
{
  NSURL * someUrl = [NSURL URLWithString:@"http://penck.de/browserreload/faq/"];
  [[NSWorkspace sharedWorkspace] openURL:someUrl];  
}

- (IBAction)clickAdd:(id)sender 
{
  [[self configurationsController] add:nil];
  [self saveAction:sender];
}

- (IBAction)clickRemove:(id)sender
{
  [[self configurationsController] remove:nil];
  [self saveAction:sender];
}


#pragma mark -
#pragma mark CoreData

- (NSURL *)applicationFilesDirectory
{
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
  return [appSupportURL URLByAppendingPathComponent:@"com.borispenck.SomethingChanged"];
}

- (NSManagedObjectModel *)managedObjectModel
{
  if (__managedObjectModel) {
    return __managedObjectModel;
  }
	
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SomethingChanged" withExtension:@"momd"];
  __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator) {
        return __persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![[properties objectForKey:NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"SomethingChanged.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    __persistentStoreCoordinator = coordinator;
    
    return __persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    __managedObjectContext = [[NSManagedObjectContext alloc] init];
    [__managedObjectContext setPersistentStoreCoordinator:coordinator];

    return __managedObjectContext;
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}



- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    if (!__managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}


@end
