//
//  NSImage+vImageProcess.m
//  vImageProcessor
//
//  Created by lizhuoli on 2017/11/22.
//

#if TARGET_OS_OSX

#import "NSImage+vImageProcess.h"
#import "vImageProcessor.h"
#import <libextobjc/extobjc.h>

@implementation NSImage (vImageProcess)

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

- (CGImageRef)CGImage {
    NSRect imageRect = NSMakeRect(0, 0, self.size.width, self.size.height);
    CGImageRef cgImage = [self CGImageForProposedRect:&imageRect context:NULL hints:nil];
    return cgImage;
}

+ (NSImage *)imageWithCGImage:(CGImageRef)cgImage
{
    return [[NSImage alloc] initWithCGImage:cgImage size:CGSizeZero];
}

- (NSImage *)vImage_alphaBlendedImageWithColor:(NSColor *)color
{
    CGImageRef processedImage = [vImageProcessor alphaBlendedImageWithImage:self.CGImage color:color.CGColor];
    CGImageRef imageRef = vImageCreateDecompressedImage(processedImage);
    CGImageRelease(processedImage);
    NSImage *image = [NSImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

- (NSImage *)vImage_alphaBlendedImageWithImage:(NSImage *)aImage point:(CGPoint)point
{
    CGImageRef processedImage = [vImageProcessor alphaBlendedImageWithImage:self.CGImage image:aImage.CGImage point:point];
    CGImageRef imageRef = vImageCreateDecompressedImage(processedImage);
    CGImageRelease(processedImage);
    NSImage *image = [NSImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

- (NSImage *)vImage_scaledImageWithSize:(CGSize)size
{
    CGImageRef processedImage = [vImageProcessor scaledImageWithImage:self.CGImage size:size];
    CGImageRef imageRef = vImageCreateDecompressedImage(processedImage);
    CGImageRelease(processedImage);
    NSImage *image = [NSImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

- (NSImage *)vImage_croppedImageWithRect:(CGRect)rect
{
    CGImageRef processedImage = [vImageProcessor croppedImageWithImage:self.CGImage rect:rect];
    CGImageRef imageRef = vImageCreateDecompressedImage(processedImage);
    CGImageRelease(processedImage);
    NSImage *image = [NSImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

- (NSImage *)vImage_flippedImageWithHorizontal:(BOOL)horizontal
{
    CGImageRef processedImage = [vImageProcessor flippedImageWithImage:self.CGImage horizontal:horizontal];
    CGImageRef imageRef = vImageCreateDecompressedImage(processedImage);
    CGImageRelease(processedImage);
    NSImage *image = [NSImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

- (NSImage *)vImage_rotatedImageWithRadians:(CGFloat)radians
{
    CGImageRef processedImage = [vImageProcessor rotatedImageWithImage:self.CGImage radians:radians];
    CGImageRef imageRef = vImageCreateDecompressedImage(processedImage);
    CGImageRelease(processedImage);
    NSImage *image = [NSImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

- (NSImage *)vImage_shearedImageWithHorizontal:(BOOL)horizontal offset:(CGVector)offset translation:(CGFloat)translation slope:(CGFloat)slope scale:(CGFloat)scale
{
    CGImageRef processedImage = [vImageProcessor shearedImageWithImage:self.CGImage horizontal:horizontal offset:offset translation:translation slope:slope scale:scale];
    CGImageRef imageRef = vImageCreateDecompressedImage(processedImage);
    CGImageRelease(processedImage);
    NSImage *image = [NSImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

- (NSImage *)vImage_affineTransformedImageWithTransform:(CGAffineTransform)transform
{
    CGImageRef processedImage = [vImageProcessor affineTransformedImageWithImage:self.CGImage transform:transform];
    CGImageRef imageRef = vImageCreateDecompressedImage(processedImage);
    CGImageRelease(processedImage);
    NSImage *image = [NSImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

@end

#endif
