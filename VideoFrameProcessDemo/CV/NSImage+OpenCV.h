#import <Cocoa/Cocoa.h>
#import "opencv2/opencv.hpp"

@interface NSImage (OpenCV)

+ (NSImage*)fromCVMat:(const cv::Mat&)cvMat;

+ (cv::Mat)toCVMat:(NSImage*)image;
- (cv::Mat)toCVMat;

@end
