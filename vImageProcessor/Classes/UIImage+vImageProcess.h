//
//  UIImage+vImageProcess.h
//  vImageProcessor
//
//  Created by lizhuoli on 2017/11/10.
//

#if TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH

#import <UIKit/UIKit.h>

@interface UIImage (vImageProcess)

// apply alpha blending for color
- (UIImage *)vImage_alphaBlendedImageWithColor:(UIColor *)color;
// apply alpha blending for image
- (UIImage *)vImage_alphaBlendedImageWithImage:(UIImage *)aImage point:(CGPoint)point;
// apply scale for size
- (UIImage *)vImage_scaledImageWithSize:(CGSize)size;
// apply cropping for rect
- (UIImage *)vImage_croppedImageWithRect:(CGRect)rect;
// apply vertical or horizontal flipping
- (UIImage *)vImage_flippedImageWithHorizontal:(BOOL)horizontal;
// apply rotation for radians
- (UIImage *)vImage_rotatedImageWithRadians:(CGFloat)radians;
// apply vertical or horizontal shearing
- (UIImage *)vImage_shearedImageWithHorizontal:(BOOL)horizontal offset:(CGVector)offset translation:(CGFloat)translation slope:(CGFloat)slope scale:(CGFloat)scale;
// apply affine transform
- (UIImage *)vImage_affineTransformedImageWithTransform:(CGAffineTransform)transform;

@end

#endif
