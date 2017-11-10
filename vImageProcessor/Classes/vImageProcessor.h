//
//  vImageProcessor.h
//  vImageDemo
//
//  Created by dreampiggy on 2017/11/9.
//  Copyright (c) 2017 dreampiggy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

// vImage for image processing
// Returned CGImage are new created and you are responsed to free it by `CGImageRelease` after usage.
// These methods use Core Graphics coordinate system instead of UIKit coordinate system, which is Y-axis positive. Ensure your call with offset, rect, affine transform with the correct coordinate system.

@interface vImageProcessor : NSObject

// apply alpha blending for color
+ (CGImageRef)alphaBlendedImageWithImage:(CGImageRef)aImage color:(CGColorRef)color;
// apply alpha blending for image
+ (CGImageRef)alphaBlendedImageWithImage:(CGImageRef)aImage image:(CGImageRef)bImage offset:(CGVector)offset;
// apply scale for size
+ (CGImageRef)scaledImageWithImage:(CGImageRef)aImage size:(CGSize)size;
// apply cropping for rect
+ (CGImageRef)croppedImageWithImage:(CGImageRef)aImage rect:(CGRect)rect;
// apply vertical or horizontal flipping
+ (CGImageRef)flippedImageWithImage:(CGImageRef)aImage horizontal:(BOOL)horizontal;
// apply rotation for radians
+ (CGImageRef)rotatedImageWithImage:(CGImageRef)aImage radians:(CGFloat)radians;
// apply vertical or horizontal shearing
+ (CGImageRef)shearedImageWithImage:(CGImageRef)aImage horizontal:(BOOL)horizontal offset:(CGVector)offset translation:(CGFloat)translation slope:(CGFloat)slope scale:(CGFloat)scale;
// apply affine transform
+ (CGImageRef)affineTransformedImageWithImage:(CGImageRef)aImage transform:(CGAffineTransform)transform;

@end
