#ifndef ImageProcesser_hpp
#define ImageProcesser_hpp

#include <stdio.h>

#include "opencv2/opencv.hpp"

using namespace std;
using namespace cv;

class ImageProcesser
{
public:
    void processImage(int width, int height, int stride, unsigned char* data);
    Mat& getOriginalImg();
    Mat& getOutputImg();
private:
    Mat originalImg;
    Mat outputImg;
};



#endif /* ImageProcesser_hpp */
