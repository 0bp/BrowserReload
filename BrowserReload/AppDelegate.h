#import <Cocoa/Cocoa.h>
#import "FSEventDispatcher.h"
#import "Action.h"
#import "ActionProperties.h"
#import "FolderNameTransformer.h"
#import "FolderCellTransformer.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDelegate>
{
  NSMutableArray * _running;
}

@property (assign) IBOutlet NSWindow *window;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak) IBOutlet NSTextField *directoryTextfield;
@property (weak) IBOutlet NSTextField *scriptTextfield;
@property (weak) IBOutlet NSArrayController *configurationsController;
@property (strong) IBOutlet NSPanel *aboutPanel;

- (IBAction)saveAction:(id)sender;
- (IBAction)clickSelectMonitorDirectory:(id)sender;
- (IBAction)clickSelectScriptFile:(id)sender;
- (IBAction)clickHelp:(id)sender;
- (IBAction)clickAdd:(id)sender;
- (IBAction)clickRemove:(id)sender;
- (IBAction)clickAbout:(id)sender;
- (IBAction)clickVisit:(id)sender;
- (IBAction)clickCloseWindow:(id)sender;

@end
