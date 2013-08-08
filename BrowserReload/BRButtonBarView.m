#import "BRButtonBarView.h"

@implementation BRButtonBarView

- (void)drawRect:(NSRect)rect
{
  [[NSColor colorWithSRGBRed:1.0f green:1.0f blue:1.0f alpha:0.4f] set];
  [NSBezierPath fillRect: [self bounds]];

  NSColor * startingColor2 = [NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
  NSColor * endingColor2 =   [NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
  
  NSGradient* aGradient2 = [[NSGradient alloc]
                            initWithStartingColor:startingColor2
                            endingColor:endingColor2]; 
  
  NSRect shadow = NSMakeRect(self.bounds.origin.x+self.bounds.size.width-4,
                             self.bounds.origin.y,
                             4, 
                             self.bounds.size.height);
  
  [aGradient2 drawInRect:shadow angle:180];
}

@end

