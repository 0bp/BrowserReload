#import "NavigationView.h"

@implementation NavigationView

- (void)drawRect:(NSRect)dirtyRect
{
  NSColor * startingColor2 = [NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
  NSColor * endingColor2 =   [NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
  
  NSGradient* aGradient2 = [[NSGradient alloc]
                            initWithStartingColor:startingColor2
                            endingColor:endingColor2]; 
  
  NSRect rect = [self bounds];
  [[NSColor colorWithPatternImage:[NSImage imageNamed:@"irongrip.png"]] set];
  [NSBezierPath fillRect: rect];

  NSRect shadow = NSMakeRect(self.bounds.origin.x+self.bounds.size.width-4,
                             self.bounds.origin.y,
                             4, 
                             self.bounds.size.height);
  
  NSRect shadow2 = NSMakeRect(self.bounds.origin.x, 
                             32,
                             self.bounds.size.width, 
                             4);
  
  [aGradient2 drawInRect:shadow angle:180];
  [aGradient2 drawInRect:shadow2 angle:90];
}

@end
