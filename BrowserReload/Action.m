#import "Action.h"
#import "ASActions.h"

@implementation Action

-(id)initWithProperties:(ActionProperties *)properties
{
  if((self = [super init]))
  {
    _properties = properties;
  }
  return self;
}

-(void)execute
{
  if(_properties.enabled)
  {
    if(_properties.script == nil || [_properties.script isEqualToString:@""])
    {
      [self reloadBrowser];
    }
    else
    {
      [self runScript];
    }
  }
}

-(void)runScript
{
  dispatch_async(dispatch_get_global_queue(0,0), ^{

    NSArray * arguments = [NSArray arrayWithObjects:_properties.folder, _properties.datetime, nil];

    NSTask * task = [[NSTask alloc] init];
    [task setLaunchPath: _properties.script];
    [task setArguments: arguments];
    
    if([[NSFileManager defaultManager] isExecutableFileAtPath:[task launchPath]])
    {
      [task launch];
      [task waitUntilExit];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [self reloadBrowser];
    });
  });  
}

-(void)reloadBrowser
{
  if(_properties.safari)
  {
    [ASActions reloadSafariTabWithLocation:_properties.match];
  }
  if(_properties.chrome)
  {
    [ASActions reloadChromeTabWithLocation:_properties.match];
  }
  [[NSNotificationCenter defaultCenter] postNotificationName:@"actionCompleted" 
                                                      object:self 
                                                    userInfo:[NSDictionary dictionaryWithObject:_properties forKey:@"properties"]];
}

@end
