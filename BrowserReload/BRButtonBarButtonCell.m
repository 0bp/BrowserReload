#import "BRButtonBarButtonCell.h"

@implementation BRButtonBarButtonCell

-(void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
  if([self isHighlighted]) 
  {
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:cellFrame xRadius:3.0 yRadius:3.0];
    [path addClip];
    
    [[NSColor colorWithSRGBRed:1.0f green:1.0f blue:1.0f alpha:0.4f] set];
    [NSBezierPath fillRect: cellFrame];
    
  }
  [self setHighlighted:NO];
  [super drawInteriorWithFrame:cellFrame inView:controlView];
}

@end
