#import <Foundation/Foundation.h>
#import "ASActions.h"
#import "ActionProperties.h"

@interface Action : NSObject
{
  ActionProperties * _properties;
}

-(id)initWithProperties:(ActionProperties *)properties;
-(void)execute;

@end
