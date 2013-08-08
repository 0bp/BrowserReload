#import "FolderNameTransformer.h"

@implementation FolderNameTransformer

+ (Class)transformedValueClass
{
  return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
  return NO;
}

- (id)transformedValue:(id)value
{
  return [value lastPathComponent];
}

@end
