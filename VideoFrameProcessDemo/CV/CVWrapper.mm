#import "CVWrapper.h"
#import "ImageProcesser.hpp"
#import "NSImage+OpenCV.h"

@implementation CVWrapper {
    ImageProcesser * processer;
}


+ (id)sharedWrapper {
    static CVWrapper* sharedWrapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWrapper = [[self alloc] init];
    });
    return sharedWrapper;
}

- (id)init {
    self = [super init];
    if (self) {
        processer = new ImageProcesser();
    }
    return self;
}


- (void)processFrameBuffer:(CVImageBufferRef)buffer {
    
    uint8_t *baseAddress = (uint8_t*)CVPixelBufferGetBaseAddress(buffer);
    size_t width = CVPixelBufferGetWidth(buffer);
    size_t height = CVPixelBufferGetHeight(buffer);
    size_t stride = CVPixelBufferGetBytesPerRow(buffer);
    processer->processImage((int)width, (int)height, (int)stride, baseAddress);
}

- (NSImage*)getOriginalImg {
    NSImage *img = [NSImage fromCVMat:processer->getOriginalImg()];
    return img;
}

- (NSImage*)getOutputImg {
    NSImage *img = [NSImage fromCVMat:processer->getOutputImg()];
    return img;
}


@end
