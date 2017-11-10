//
//  UIImage+vImageProcess.m
//  vImageProcessor
//
//  Created by lizhuoli on 2017/11/10.
//

#import "UIImage+vImageProcess.h"
#import "vImageProcessor.h"

@implementation UIImage (vImageProcess)

- (UIImage *)vImage_alphaBlendedImageWithColor:(UIColor *)color
{
    CGImageRef imageRef = [vImageProcessor alphaBlendedImageWithImage:self.CGImage color:color.CGColor];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)vImage_alphaBlendedImageWithImage:(UIImage *)aImage
{
    CGImageRef imageRef = [vImageProcessor alphaBlendedImageWithImage:self.CGImage image:aImage.CGImage];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)vImage_scaledImageWithSize:(CGSize)size
{
    CGImageRef imageRef = [vImageProcessor scaledImageWithImage:self.CGImage size:size];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)vImage_croppedImageWithRect:(CGRect)rect
{
    CGImageRef imageRef = [vImageProcessor croppedImageWithImage:self.CGImage rect:rect];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)vImage_flippedImageWithHorizontal:(BOOL)horizontal
{
    CGImageRef imageRef = [vImageProcessor flippedImageWithImage:self.CGImage horizontal:horizontal];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)vImage_rotatedImageWithRadians:(CGFloat)radians
{
    CGImageRef imageRef = [vImageProcessor rotatedImageWithImage:self.CGImage radians:radians];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)vImage_shearedImageWithHorizontal:(BOOL)horizontal offset:(CGVector)offset translation:(CGFloat)translation slope:(CGFloat)slope scale:(CGFloat)scale
{
    CGImageRef imageRef = [vImageProcessor shearedImageWithImage:self.CGImage horizontal:horizontal offset:offset translation:translation slope:slope scale:scale];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)vImage_affineTransformedImageWithTransform:(CGAffineTransform)transform
{
    CGImageRef imageRef = [vImageProcessor affineTransformedImageWithImage:self.CGImage transform:transform];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

@end
