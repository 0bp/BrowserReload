#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>

@interface FSEventDispatcher : NSObject
{
  FSEventStreamRef stream;
}

- (void)start;
- (void)stop;

@end
