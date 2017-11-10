//
//  UIImage+vImageProcess.m
//  vImageProcessor
//
//  Created by lizhuoli on 2017/11/10.
//

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

// Core Animation specify premultiplied-alpha instead of vImage's format
// This will improving rendering performance(frame rate) and avoid extra `CA::Render::copy_image` call
static CGImageRef vImageCreateDecompressedImage(CGImageRef image)
{
    __block CGContextRef context = NULL;
    @onExit {
        if (context) CFRelease(context);
        if (image) CGImageRelease(image);
    };
    CGFloat width = CGImageGetWidth(image);
    CGFloat height = CGImageGetHeight(image);
    CGRect rect = CGRectMake(0, 0, width, height);
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrderDefault;
    context = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, vImageColorSpaceGetDeviceRGB(), bitmapInfo);    
    if (!context) {
        return CGImageCreateCopy(image);
    }
    CGContextDrawImage(context, rect, image);
    return CGBitmapContextCreateImage(context);
}

- (UIImage *)vImage_alphaBlendedImageWithColor:(UIColor *)color
{
    CGImageRef imageRef = [vImageProcessor alphaBlendedImageWithImage:self.CGImage color:color.CGColor];
    imageRef = vImageCreateDecompressedImage(imageRef);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)vImage_alphaBlendedImageWithImage:(UIImage *)aImage offset:(CGVector)offset
{
    CGImageRef imageRef = [vImageProcessor alphaBlendedImageWithImage:self.CGImage image:aImage.CGImage offset:offset];
    imageRef = vImageCreateDecompressedImage(imageRef);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)vImage_scaledImageWithSize:(CGSize)size
{
    CGImageRef imageRef = [vImageProcessor scaledImageWithImage:self.CGImage size:size];
    imageRef = vImageCreateDecompressedImage(imageRef);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)vImage_croppedImageWithRect:(CGRect)rect
{
    CGImageRef imageRef = [vImageProcessor croppedImageWithImage:self.CGImage rect:rect];
    imageRef = vImageCreateDecompressedImage(imageRef);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)vImage_flippedImageWithHorizontal:(BOOL)horizontal
{
    CGImageRef imageRef = [vImageProcessor flippedImageWithImage:self.CGImage horizontal:horizontal];
    imageRef = vImageCreateDecompressedImage(imageRef);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)vImage_rotatedImageWithRadians:(CGFloat)radians
{
    CGImageRef imageRef = [vImageProcessor rotatedImageWithImage:self.CGImage radians:radians];
    imageRef = vImageCreateDecompressedImage(imageRef);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)vImage_shearedImageWithHorizontal:(BOOL)horizontal offset:(CGVector)offset translation:(CGFloat)translation slope:(CGFloat)slope scale:(CGFloat)scale
{
    CGImageRef imageRef = [vImageProcessor shearedImageWithImage:self.CGImage horizontal:horizontal offset:offset translation:translation slope:slope scale:scale];
    imageRef = vImageCreateDecompressedImage(imageRef);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)vImage_affineTransformedImageWithTransform:(CGAffineTransform)transform
{
    CGImageRef imageRef = [vImageProcessor affineTransformedImageWithImage:self.CGImage transform:transform];
    imageRef = vImageCreateDecompressedImage(imageRef);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

@end
