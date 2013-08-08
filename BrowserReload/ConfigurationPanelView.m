#import "ConfigurationPanelView.h"

@implementation ConfigurationPanelView

- (void)drawRect:(NSRect)dirtyRect
{
  NSRect rect = [self bounds];
  
  NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect
                                                       xRadius:5.0
                                                       yRadius:5.0];
  [path addClip];
  
  [[NSColor colorWithCalibratedRed:1.0
                             green:1.0
                              blue:1.0
                             alpha:0.75] set];
  
  [NSBezierPath fillRect: rect];
  
  [super drawRect:dirtyRect];
}

@end
