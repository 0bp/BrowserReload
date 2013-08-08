#import "FSEventDispatcher.h"

@implementation FSEventDispatcher

static void feCallback(ConstFSEventStreamRef streamRef, void *clientCallBackInfo, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[]) 
{
  NSDate *time = [NSDate date];
  char ** paths = eventPaths;

  int i;
  for (i = 0; i < numEvents; i++) {
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithUnsignedLongLong:eventIds[i]], @"id",
                           [NSString stringWithUTF8String:paths[i]], @"path",
                           [NSString stringWithFormat:@"0x%.8x",eventFlags[i]] , @"flag",
                           time , @"time",
                           nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FSFileInPathChangedNotification" 
                                                        object:nil 
                                                      userInfo:dict];
  }
}

- (id)init
{
  if((self = [super init]))
  {

    CFStringRef path = CFSTR("/");
    CFArrayRef pathsToWatch = CFArrayCreate(NULL, (const void **)&path, 1, NULL);
    
    FSEventStreamContext context = {0, NULL, NULL, NULL, NULL};
    
    stream = FSEventStreamCreate(kCFAllocatorDefault,
                                 &feCallback,
                                 &context,
                                 pathsToWatch,
                                 kFSEventStreamEventIdSinceNow,
                                 0.3, 
                                 kFSEventStreamCreateFlagNone
                                 );
    
    FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);  
    
    CFRelease(path);
    CFRelease(pathsToWatch);
  }
  return self;
}

- (void)start
{
  FSEventStreamStart(stream);
}

- (void)stop
{
  FSEventStreamFlushSync(stream);
  FSEventStreamStop(stream);
}

@end
