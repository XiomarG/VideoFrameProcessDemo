#include "ImageProcesser.hpp"
#include <iostream>

void ImageProcesser::processImage(int width, int height, int stride, unsigned char* data)
{
    this->originalImg = Mat(height, width, CV_8UC4, data, stride);
    Mat grayImg, th;
    cvtColor(this->originalImg, this->originalImg, CV_RGB2BGR);
    
    cvtColor(this->originalImg, grayImg, CV_BGR2GRAY);
    vector<vector<Point> > contours;
    vector<Vec4i> hierarchy;
    double otsu_thresh_val = threshold(grayImg, th, 0, 255,  CV_THRESH_BINARY | CV_THRESH_OTSU);
    double high_thresh_val  = otsu_thresh_val,
    lower_thresh_val = otsu_thresh_val * 0.5;
    Canny(grayImg, grayImg, lower_thresh_val, high_thresh_val);
    vector<Mat> channels = {grayImg, grayImg, grayImg};
    merge(channels, this->outputImg);
}

Mat& ImageProcesser::getOriginalImg()
{
    return this->originalImg;
}
Mat& ImageProcesser::getOutputImg()
{
    return this->outputImg;
}

