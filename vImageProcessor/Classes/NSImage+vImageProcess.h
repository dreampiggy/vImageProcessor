//
//  NSImage+vImageProcess.h
//  vImageProcessor
//
//  Created by lizhuoli on 2017/11/22.
//

#if TARGET_OS_OSX

#import <AppKit/AppKit.h>

@interface NSImage (vImageProcess)

// apply alpha blending for color
- (NSImage *)vImage_alphaBlendedImageWithColor:(NSColor *)color;
// apply alpha blending for image
- (NSImage *)vImage_alphaBlendedImageWithImage:(NSImage *)aImage point:(CGPoint)point;
// apply scale for size
- (NSImage *)vImage_scaledImageWithSize:(CGSize)size;
// apply cropping for rect
- (NSImage *)vImage_croppedImageWithRect:(CGRect)rect;
// apply vertical or horizontal flipping
- (NSImage *)vImage_flippedImageWithHorizontal:(BOOL)horizontal;
// apply rotation for radians
- (NSImage *)vImage_rotatedImageWithRadians:(CGFloat)radians;
// apply vertical or horizontal shearing
- (NSImage *)vImage_shearedImageWithHorizontal:(BOOL)horizontal offset:(CGVector)offset translation:(CGFloat)translation slope:(CGFloat)slope scale:(CGFloat)scale;
// apply affine transform
- (NSImage *)vImage_affineTransformedImageWithTransform:(CGAffineTransform)transform;

@end

#endif
