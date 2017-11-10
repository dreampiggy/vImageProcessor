//
//  vImageProcessor.h
//  vImageDemo
//
//  Created by dreampiggy on 2017/11/9.
//  Copyright (c) 2017 dreampiggy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

// vImage for image processing
// Returned CGImage are all new created following `The Create Rule`. You are responsed to free it by `CGImageRelease` after usage.
// These methods use Core Graphics coordinate system instead of UIKit coordinate system, which is Y-axis positive. Ensure your call with offset, rect, affine transform with the correct coordinate system.

@interface vImageProcessor : NSObject

// apply alpha blending for color
+ (CGImageRef _Nullable)alphaBlendedImageWithImage:(CGImageRef)aImage color:(CGColorRef)color;
// apply alpha blending for image
+ (CGImageRef _Nullable)alphaBlendedImageWithImage:(CGImageRef)aImage image:(CGImageRef)bImage offset:(CGVector)offset;
// apply scale for size
+ (CGImageRef _Nullable)scaledImageWithImage:(CGImageRef)aImage size:(CGSize)size;
// apply cropping for rect
+ (CGImageRef _Nullable)croppedImageWithImage:(CGImageRef)aImage rect:(CGRect)rect;
// apply vertical or horizontal flipping
+ (CGImageRef _Nullable)flippedImageWithImage:(CGImageRef)aImage horizontal:(BOOL)horizontal;
// apply rotation for radians
+ (CGImageRef _Nullable)rotatedImageWithImage:(CGImageRef)aImage radians:(CGFloat)radians;
// apply vertical or horizontal shearing
+ (CGImageRef _Nullable)shearedImageWithImage:(CGImageRef)aImage horizontal:(BOOL)horizontal offset:(CGVector)offset translation:(CGFloat)translation slope:(CGFloat)slope scale:(CGFloat)scale;
// apply affine transform
+ (CGImageRef _Nullable)affineTransformedImageWithImage:(CGImageRef)aImage transform:(CGAffineTransform)transform;

@end

NS_ASSUME_NONNULL_END
