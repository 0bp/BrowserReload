#import <Foundation/Foundation.h>

@interface ASActions : NSObject

+ (void)reloadSafariTabWithLocation:(NSString *)location;
+ (void)reloadChromeTabWithLocation:(NSString *)location;

@end
