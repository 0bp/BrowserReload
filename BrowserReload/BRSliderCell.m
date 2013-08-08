#import "BRSliderCell.h"

@implementation BRSliderCell

- (NSColor *)highlightColorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
  return nil;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
  NSRect backgroundFrame = cellFrame;
  
  if([self isHighlighted]) {
    
    backgroundFrame.origin.x -= 1;
    backgroundFrame.origin.y -= 1;
    backgroundFrame.size.height += 2;
    backgroundFrame.size.width += 3;
    
    
    NSColor * topBorder = [NSColor colorWithSRGBRed:0.54f green:0.78f blue:0.94f alpha:1.0f];
    NSColor * topBorder2 = [NSColor colorWithSRGBRed:0.54f green:0.78f blue:0.94f alpha:1.0f];
    NSColor * topColor = [NSColor colorWithSRGBRed:0.27f green:0.62f blue:0.9f alpha:1.0f];
    NSColor * bottomColor = [NSColor colorWithSRGBRed:0.15f green:0.47f blue:0.82f alpha:1.0f];
    NSColor * shadowTop = [NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    NSColor * shadowBottom = [NSColor colorWithSRGBRed:0.1f green:0.1f blue:0.1f alpha:1.0f];
    
    NSGradient * gradient = [[NSGradient alloc] initWithColorsAndLocations:
                             topBorder, 0.0f,
                             topBorder2, 0.043f,
                             topColor, 0.043f,
                             bottomColor, 0.957f,
                             shadowTop,0.957f,              
                             shadowBottom,1.0f,              
                             nil];
    
    [gradient drawInRect:backgroundFrame angle:90.0f];
  }
  
  /* Shadow Right */
  NSColor * startingColor2 = [NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:0.4f];
  NSColor * endingColor2 =   [NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
  
  NSGradient* aGradient2 = [[NSGradient alloc]
                            initWithStartingColor:startingColor2
                            endingColor:endingColor2];
  
  NSRect shadow = NSMakeRect(cellFrame.origin.x+cellFrame.size.width-2, 
                             cellFrame.origin.y-2,
                             4, 
                             cellFrame.size.height+2);
  
  [aGradient2 drawInRect:shadow angle:180];  
  
  [super drawWithFrame:cellFrame inView:controlView];
}

-(NSRect)knobRectFlipped:(BOOL)flipped
{
  CGFloat value = [self intValue];
  NSRect myRect = [super knobRectFlipped:flipped];
  
  myRect.size.width = self.trackRect.size.height-2;
  myRect.size.height = self.trackRect.size.height-2;
  myRect.origin.x = (value * (self.trackRect.size.width-17 - myRect.size.width))+7;
  myRect.origin.y = self.trackRect.origin.y+1;
  
  return myRect;
}

-(void)drawKnob:(NSRect)knobRect
{
  knobRect.origin.x += self.trackRect.origin.x - 1;
  
  NSBezierPath * clipShape = [NSBezierPath bezierPath];
  [clipShape appendBezierPathWithRoundedRect:knobRect xRadius:20 yRadius:20];
  
  NSRect innerRect = knobRect;
  innerRect.origin.x += 1;
  innerRect.origin.y += 1;
  innerRect.size.width -= 2;
  innerRect.size.height -=2;
  
  NSBezierPath * innerShape = [NSBezierPath bezierPath]; 
  [innerShape appendBezierPathWithRoundedRect:innerRect xRadius:20 yRadius:20];
  
  NSColor * knobTopColor;
  NSColor * knobBottomColor;
  NSColor * knobBorderLight;
  
  if(![self isEnabled]) {
    knobBorderLight = [NSColor colorWithSRGBRed:0.6f green:0.6f blue:0.6f alpha:1.0f];
    knobTopColor = [NSColor colorWithSRGBRed:0.6f green:0.6f blue:0.6f alpha:1.0f];
    knobBottomColor = [NSColor colorWithSRGBRed:0.6f green:0.6f blue:0.6f alpha:1.0f];
  } else {
    knobBorderLight = [NSColor whiteColor];
    knobTopColor = [NSColor colorWithSRGBRed:0.72f green:0.72f blue:0.72f alpha:1.0f];
    knobBottomColor = [NSColor colorWithSRGBRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
  }
  
  NSGradient * knobBorder = [[NSGradient alloc] initWithColorsAndLocations:knobBorderLight, 0.0f, nil];
  
  NSGradient * knobGradient = [[NSGradient alloc]
                               initWithColorsAndLocations:
                               knobTopColor, 0.0f,
                               knobBottomColor, 1.0f,
                               nil];
  
  [knobBorder drawInBezierPath:clipShape angle:0];
  [knobGradient drawInBezierPath:innerShape angle:90.0f];  
}


- (void)drawBarInside:(NSRect)rect flipped:(BOOL)flipped
{
  rect.origin.x += 5;  
  rect.size.width -= 15;
  
  /* Draw Background */
  NSBezierPath * barShape = [NSBezierPath bezierPath];
  [barShape appendBezierPathWithRoundedRect:rect xRadius:rect.size.height/2 yRadius:rect.size.height/2];
  
  NSGradient *fill = [[NSGradient alloc] initWithColorsAndLocations:
                      [NSColor colorWithCalibratedRed:0.247 green:0.251 blue:0.267 alpha:0.6],0.0f,
                      [NSColor colorWithCalibratedRed:0.227 green:0.227 blue:0.239 alpha:0.6],0.5f,
                      [NSColor colorWithCalibratedRed:0.180 green:0.188 blue:0.196 alpha:0.6],0.5f,
                      [NSColor colorWithCalibratedRed:0.137 green:0.137 blue:0.157 alpha:0.6],1.0f,
                      nil];
  
  [fill drawInBezierPath:barShape angle:-90.0];
  
  [[NSColor colorWithCalibratedRed:0.04 green:0.0f blue:0.0f alpha:0.3] set];
  [barShape stroke];
  
  /* Draw Text */
  CGFloat fontSize = 9.0f;
  NSString * fontName = @"Helvetica";
  NSString * message;
  
  if([self intValue] == 1) {
    message = @"ON";
  } else {
    message = @"OFF";
  }
  
  
  NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSFont fontWithName:fontName size:fontSize],
                               NSFontAttributeName,
                               [NSColor grayColor],
                               NSForegroundColorAttributeName,
                               nil];
  
  NSAttributedString * currentText=[[NSAttributedString alloc] initWithString:message attributes: attributes];
  
  NSPoint textPt;
  if([self intValue] == 1) {
    textPt = NSMakePoint(rect.origin.x+7, rect.origin.y+4);
  } else {
    textPt = NSMakePoint(rect.origin.x+21, rect.origin.y+4);  
  }
  
  [currentText drawAtPoint:textPt];
  
}

-(NSRect)rectOfTickMarkAtIndex:(NSInteger)index
{
  return NSMakeRect(0, 0, 0, 0);
}

- (BOOL)_usesCustomTrackImage 
{
  return YES;
}

@end
