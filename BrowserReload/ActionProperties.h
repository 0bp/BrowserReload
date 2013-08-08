#import <Foundation/Foundation.h>

@interface ActionProperties : NSObject

@property (retain, nonatomic) NSString * folder;
@property (retain, nonatomic) NSString * script;
@property (retain, nonatomic) NSString * match;
@property (retain, nonatomic) NSString * datetime;
@property (retain, nonatomic) NSString * pathId;
@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL safari;
@property (nonatomic) BOOL chrome;
@property (nonatomic) int count;

@end
