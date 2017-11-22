//
//  UIImage+vImageProcess.m
//  vImageProcessor
//
//  Created by lizhuoli on 2017/11/10.
//

#if TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH

#import "UIImage+vImageProcess.h"
#import "vImageProcessor.h"
#import <libextobjc/extobjc.h>

@implementation UIImage (vImageProcess)

static CGColorSpaceRef vImageColorSpaceGetDeviceRGB() {
    static dispatch_once_t onceToken;
    static CGColorSpaceRef colorSpace;
    dispatch_once(&onceToken, ^{
        colorSpace = CGColorSpaceCreateDeviceRGB();
    });
    return colorSpace;
}

// 64 bytes align to avoid extra `CA::Render::aligned_malloc` call
static inline size_t vImageByteAlign(size_t size, size_t alignment) {
    return ((size + (alignment - 1)) / alignment) * alignment;
}

// Convert UIKit coordinate system to Core Graphics coordinate system for CGRect
static inline CGRect vImageRectConvert(CGRect rect, CGFloat height) {
    CGFloat y = height - CGRectGetMaxY(rect);
    return CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height);
}

// Convert UIKit coordinate system to Core Graphics coordinate system for CGPoint
static inline CGPoint vImagePointConvert(CGPoint point, CGFloat height) {
    CGFloat y = height - point.y;
    return CGPointMake(point.x, y);
}

// Convert UIKit coordinate system to Core Graphics coordinate system for CGFloat Radians
static inline CGFloat vImageRadiansConvert(CGFloat radians) {
    return M_PI * 2 - radians;
}

// Convert UIKit coordinate system to Core Graphics coordinate system for CGVector
static inline CGVector vImageVectorConvert(CGVector vector) {
    return CGVectorMake(vector.dx, -vector.dy);
}

// Core Animation specify premultiplied-alpha instead of vImage's format
// This will improving rendering performance(frame rate) and avoid extra `CA::Render::copy_image` call
static CGImageRef vImageCreateDecompressedImage(CGImageRef image)
{
    CGImageRetain(image);
    __block CGContextRef context = NULL;
    @onExit {
        if (context) CFRelease(context);
        if (image) CGImageRelease(image);
    };
    CGFloat width = CGImageGetWidth(image);
    CGFloat height = CGImageGetHeight(image);
    CGRect rect = CGRectMake(0, 0, width, height);
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrderDefault;
    context = CGBitmapContextCreate(NULL, width, height, 8, vImageByteAlign(4 * width, 64), vImageColorSpaceGetDeviceRGB(), bitmapInfo);    
    if (!context) {
        return CGImageCreateCopy(image);
    }
    CGContextDrawImage(context, rect, image);
    return CGBitmapContextCreateImage(context);
}

- (UIImage *)vImage_alphaBlendedImageWithColor:(UIColor *)color
{
    CGImageRef processedImage = [vImageProcessor alphaBlendedImageWithImage:self.CGImage color:color.CGColor];
    CGImageRef imageRef = vImageCreateDecompressedImage(processedImage);
    CGImageRelease(processedImage);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)vImage_alphaBlendedImageWithImage:(UIImage *)aImage point:(CGPoint)point
{
    CGImageRef processedImage = [vImageProcessor alphaBlendedImageWithImage:self.CGImage image:aImage.CGImage point:vImagePointConvert(point, CGImageGetHeight(self.CGImage))];
    CGImageRef imageRef = vImageCreateDecompressedImage(processedImage);
    CGImageRelease(processedImage);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)vImage_scaledImageWithSize:(CGSize)size
{
    CGImageRef processedImage = [vImageProcessor scaledImageWithImage:self.CGImage size:size];
    CGImageRef imageRef = vImageCreateDecompressedImage(processedImage);
    CGImageRelease(processedImage);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)vImage_croppedImageWithRect:(CGRect)rect
{
    CGImageRef processedImage = [vImageProcessor croppedImageWithImage:self.CGImage rect:vImageRectConvert(rect, CGImageGetHeight(self.CGImage))];
    CGImageRef imageRef = vImageCreateDecompressedImage(processedImage);
    CGImageRelease(processedImage);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)vImage_flippedImageWithHorizontal:(BOOL)horizontal
{
    CGImageRef processedImage = [vImageProcessor flippedImageWithImage:self.CGImage horizontal:horizontal];
    CGImageRef imageRef = vImageCreateDecompressedImage(processedImage);
    CGImageRelease(processedImage);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)vImage_rotatedImageWithRadians:(CGFloat)radians
{
    CGImageRef processedImage = [vImageProcessor rotatedImageWithImage:self.CGImage radians:vImageRadiansConvert(radians)];
    CGImageRef imageRef = vImageCreateDecompressedImage(processedImage);
    CGImageRelease(processedImage);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)vImage_shearedImageWithHorizontal:(BOOL)horizontal offset:(CGVector)offset translation:(CGFloat)translation slope:(CGFloat)slope scale:(CGFloat)scale
{
    CGImageRef processedImage = [vImageProcessor shearedImageWithImage:self.CGImage horizontal:horizontal offset:vImageVectorConvert(offset) translation:(horizontal ? translation : -translation) slope:slope scale:scale];
    CGImageRef imageRef = vImageCreateDecompressedImage(processedImage);
    CGImageRelease(processedImage);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)vImage_affineTransformedImageWithTransform:(CGAffineTransform)transform
{
    CGImageRef processedImage = [vImageProcessor affineTransformedImageWithImage:self.CGImage transform:transform];
    CGImageRef imageRef = vImageCreateDecompressedImage(processedImage);
    CGImageRelease(processedImage);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

@end

#endif
