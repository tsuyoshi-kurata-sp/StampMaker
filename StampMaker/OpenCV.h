//
//  OpenCV.h
//  StampMaker
//
//  Created by 蔵田 剛 on 2023/02/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCV : NSObject

+ (UIImage *)convertColor: (UIImage *)image code: (int)code;
+ (UIImage *)threshold: (UIImage *)image code: (int)code;
+ (UIImage *)medianBlur: (UIImage *)image blurSize: (int)blurSize;

+ (UIImage *)transparent: (UIImage *)image transparentColor: (int)colorCode;

+ (UIImage *)clipRect: (UIImage *)image size: (CGSize)size;
+ (UIImage *)clipOval: (UIImage *)image size: (CGSize)size;
+ (UIImage *)clipCircle: (UIImage *)image size: (CGSize)size;

@end

NS_ASSUME_NONNULL_END
