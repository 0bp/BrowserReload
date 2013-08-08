#import "ASActions.h"

@implementation ASActions

+ (void)reloadSafariTabWithLocation:(NSString *)location;
{
  NSString * source = [NSString stringWithFormat:
                       @"tell application \"Safari\"\n"
                       @" repeat with i from 1 to (count of windows) by 1\n"
                       @"   if id of window i is greater than -1 then\n"
                       @"     if tabs of window i exists then\n"
                       @"       repeat with j from 1 to (count of tabs of window i) by 1\n"
                       @"         if URL of tab j of window i contains \"%@\" then\n"
                       @"           do Javascript \"window.location.reload()\" in tab j of window i\n"
                       @"         end if\n"
                       @"       end repeat\n"
                       @"     end if\n"
                       @"   end if\n"
                       @" end repeat\n"
                       @"end tell\n"
                       , location];

  NSAppleScript *run = [[NSAppleScript alloc] initWithSource:source];
  [run executeAndReturnError:nil];
}

+ (void)reloadChromeTabWithLocation:(NSString *)location;
{
  NSString * source = [NSString stringWithFormat:
                       @"tell application \"Google Chrome\"\n"
                       @" repeat with i from 1 to (count of windows) by 1\n"
                       @"   if id of window i is greater than -1 then\n"
                       @"     if tabs of window i exists then\n"
                       @"       repeat with j from 1 to (count of tabs of window i) by 1\n"
                       @"         if URL of tab j of window i contains \"%@\" then\n"
                       @"           reload tab j of window i\n"
                       @"         end if\n"
                       @"       end repeat\n"
                       @"     end if\n"
                       @"   end if\n"
                       @" end repeat\n"
                       @"end tell\n"
                       , location];
  
  NSAppleScript *run = [[NSAppleScript alloc] initWithSource:source];
  [run executeAndReturnError:nil];
}
@end
