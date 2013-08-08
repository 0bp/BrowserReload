#import "FolderCellTransformer.h"

@implementation FolderCellTransformer

+ (Class)transformedValueClass
{
  return [NSImage class];
}

+ (BOOL)allowsReverseTransformation
{
  return NO;
}

- (id)transformedValue:(id)value
{
  return [NSImage imageNamed:@"GenericFolderIcon.icns"];
}

@end
