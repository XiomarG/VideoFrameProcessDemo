#import <Foundation/Foundation.h>
#import "AVFoundation/AVFoundation.h"

@interface CVWrapper : NSObject

+ (id)sharedWrapper;

- (void)processFrameBuffer:(CVImageBufferRef)buffer;
- (NSImage*)getOriginalImg;
- (NSImage*)getOutputImg;
@end

