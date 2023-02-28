//
//  OpenCV.mm
//  StampMaker
//
//  Created by 蔵田 剛 on 2023/02/07.
//
#import <opencv2/core/core.hpp>
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/imgproc.hpp>
#import <opencv2/imgproc/imgproc.hpp>
#import <opencv2/highgui/highgui.hpp>
#import <opencv2/imgproc/types_c.h>
#import "OpenCV.h"

@implementation OpenCV

+ (UIImage *)convertColor: (UIImage *)image code: (int)code {
  cv::Mat src;
  cv::Mat dst;
  UIImageToMat(image, src);
  
  cv::cvtColor(src, dst, code);
  
  return MatToUIImage(dst);
}

+ (UIImage *)threshold: (UIImage *)image code: (int)code {
  if (code < 0) {
    return image;
  }
  
  cv::Mat src;
  cv::Mat dst;
  UIImageToMat(image, src);
  cv::cvtColor(src, src, cv::COLOR_RGB2GRAY);
  
  try {
    cv::threshold(src, dst, 128, 255, code);
  } catch (cv::Exception& e) {
    const char* err_msg = e.what();
    NSLog(@"Mat.threshold(): %s", err_msg);
    NSLog(@"%@",[NSThread callStackSymbols]);
    return nil;
  }
  
  return MatToUIImage(dst);
}

+ (UIImage *)medianBlur: (UIImage *)image blurSize: (int)blurSize {
  cv::Mat src;
  cv::Mat dst;
  UIImageToMat(image, src);
  
  try {
    cv::medianBlur(src, dst, blurSize);
  } catch (cv::Exception& e) {
    const char* err_msg = e.what();
    NSLog(@"Mat.medianBlur(): %s", err_msg);
    NSLog(@"%@",[NSThread callStackSymbols]);
    return nil;
  }
  return MatToUIImage(dst);
}

+ (UIImage *)transparent: (UIImage *)image transparentColor: (int)colorCode {
  cv::Mat src;
  UIImageToMat(image, src);
  
  cv::Mat alpha_src;
  cv::Mat alpha_dst(src.size(), CV_8UC4);
  
  if (src.type() == CV_8UC4) {
    cv::cvtColor(src, alpha_src, CV_BGRA2BGR);
    std::cout << "CV_BGRA2BGR" << std::endl;
  }
  else if (src.type() == CV_8UC1) {
    std::cout << "CV_GRAY2BGR" << std::endl;
    cv::cvtColor(src, alpha_src, CV_GRAY2BGR);
  }
  else if (src.type() == CV_8UC3) {
    alpha_src = src;
  }
  else {
    throw std::exception();
  }
  
  for (int y = 0; y < alpha_src.rows; y++) {
    for (int x = 0; x < alpha_src.cols; x++) {
      cv::Vec3b p = alpha_src.at<cv::Vec3b>(cv::Point(x, y));
      if (p[0] + p[1] + p[2] > (255 * 3 - 30)) {//好きな条件
        alpha_dst.at<cv::Vec4b>(cv::Point(x, y)) = cv::Vec4b(p[0], p[1], p[2], 0); //透過
      }
      else {
        alpha_dst.at<cv::Vec4b>(cv::Point(x, y)) = cv::Vec4b(p[0], p[1], p[2], 255); //不透過
      }
    }
  }
  return MatToUIImage(alpha_dst);
}

+ (UIImage *)clipRect: (UIImage *)image size: (CGSize)size {
  cv::Mat src;
  UIImageToMat(image, src);
  
  cv::Mat dst = cv::Mat(src, cv::Rect(100,0,300,340));
  
  return MatToUIImage(dst);
}

+ (UIImage *)clipOval: (UIImage *)image size: (CGSize)size {
  cv::Mat src;
  UIImageToMat(image, src);
  
  cv::Mat dst = cv::Mat(src, cv::Rect(100,0,300,340));
  
  return MatToUIImage(dst);
}

+ (UIImage *)clipCircle: (UIImage *)image size: (CGSize)size {
  cv::Mat src;
  cv::Mat dst;
  UIImageToMat(image, src);
  dst = src.clone();

  cv::circle(dst, cv::Point(100,0), 95, cv::Scalar(255,0,0), 5);
  
  return MatToUIImage(dst);
}

@end
