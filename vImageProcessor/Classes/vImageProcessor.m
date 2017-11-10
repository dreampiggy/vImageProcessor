//
//  vImageProcessor.m
//  vImageDemo
//
//  Created by dreampiggy on 2017/11/9.
//  Copyright (c) 2017 dreampiggy. All rights reserved.
//

#import "vImageProcessor.h"
#import <Accelerate/Accelerate.h>
#import <libextobjc/extobjc.h>

@implementation vImageProcessor

static vImage_CGImageFormat vImageFormatARGB8888 = (vImage_CGImageFormat) {
    .bitsPerComponent = 8,
    .bitsPerPixel = 32,
    .colorSpace = NULL,
    .bitmapInfo = (CGBitmapInfo)kCGImageAlphaFirst,
    .version = 0,
    .decode = NULL,
    .renderingIntent = kCGRenderingIntentDefault,
};

+ (CGImageRef)alphaBlendedImageWithImage:(CGImageRef)aImage color:(CGColorRef)color
{
    vImage_Buffer a_buffer = {}, b_buffer = {}, output_buffer = {};
    @onExit {
        if (a_buffer.data) free(a_buffer.data);
        if (b_buffer.data) free(b_buffer.data);
        if (output_buffer.data) free(output_buffer.data);
    };
    
    vImage_Error a_ret = vImageBuffer_InitWithCGImage(&a_buffer, &vImageFormatARGB8888, NULL, aImage, kvImageNoFlags);
    if (a_ret != kvImageNoError) return NULL;
    
    b_buffer.width = a_buffer.width;
    b_buffer.height = a_buffer.height;
    b_buffer.rowBytes = a_buffer.rowBytes;
    b_buffer.data = malloc(b_buffer.rowBytes * b_buffer.height);
    output_buffer.width = a_buffer.width;
    output_buffer.height = a_buffer.height;
    output_buffer.rowBytes = a_buffer.rowBytes;
    output_buffer.data = malloc(output_buffer.rowBytes * output_buffer.height);
    if (!b_buffer.data || !output_buffer.data) return NULL;
    
    Pixel_8888 pixel_color = {0};
    const double *components = CGColorGetComponents(color);
    const size_t components_size = CGColorGetNumberOfComponents(color);
    if (components_size == 2) {
        // white, alpha
        pixel_color[0] = components[1] * 255;
    } else {
        // red, green, blue, (alpha)
        pixel_color[0] = components_size == 3 ? 255 : components[3] * 255;
        pixel_color[1] = components[0] * 255;
        pixel_color[2] = components[1] * 255;
        pixel_color[3] = components[2] * 255;
    }
    
    vImage_Error b_ret = vImageBufferFill_ARGB8888(&b_buffer, pixel_color , kvImageNoFlags);
    if (b_ret != kvImageNoError) return NULL;
    
    vImage_Error ret = vImageAlphaBlend_ARGB8888(&b_buffer, &a_buffer, &output_buffer, kvImageNoFlags);
    if (ret != kvImageNoError) return NULL;
    
    CGImageRef outputImage = vImageCreateCGImageFromBuffer(&output_buffer, &vImageFormatARGB8888, NULL, NULL, kvImageNoFlags, &ret);
    if (ret != kvImageNoError) return NULL;
    
    return outputImage;
}

+ (CGImageRef)alphaBlendedImageWithImage:(CGImageRef)aImage image:(CGImageRef)bImage
{
    vImage_Buffer a_buffer = {}, b_buffer = {}, output_buffer = {};
    @onExit {
        if (a_buffer.data) free(a_buffer.data);
        if (b_buffer.data) free(b_buffer.data);
        if (output_buffer.data) free(output_buffer.data);
    };
    
    vImage_Error a_ret = vImageBuffer_InitWithCGImage(&a_buffer, &vImageFormatARGB8888, NULL, aImage, kvImageNoFlags);
    if (a_ret != kvImageNoError) return NULL;
    vImage_Error b_ret = vImageBuffer_InitWithCGImage(&b_buffer, &vImageFormatARGB8888, NULL, bImage, kvImageNoFlags);
    if (b_ret != kvImageNoError) return NULL;
    
    output_buffer.width = a_buffer.width;
    output_buffer.height = a_buffer.height;
    output_buffer.rowBytes = a_buffer.rowBytes;
    output_buffer.data = malloc(output_buffer.rowBytes * output_buffer.height);
    if (!output_buffer.data) return NULL;
    
    vImage_Error ret = vImageAlphaBlend_ARGB8888(&b_buffer, &a_buffer, &output_buffer, kvImageNoFlags);
    if (ret != kvImageNoError) return NULL;
    
    CGImageRef outputImage = vImageCreateCGImageFromBuffer(&output_buffer, &vImageFormatARGB8888, NULL, NULL, kvImageNoFlags, &ret);
    if (ret != kvImageNoError) return NULL;
    
    return outputImage;
}

+ (CGImageRef)scaledImageWithImage:(CGImageRef)aImage size:(CGSize)size
{
    vImage_Buffer a_buffer = {}, output_buffer = {};
    @onExit {
        if (a_buffer.data) free(a_buffer.data);
        if (output_buffer.data) free(output_buffer.data);
    };
    
    vImage_Error a_ret = vImageBuffer_InitWithCGImage(&a_buffer, &vImageFormatARGB8888, NULL, aImage, kvImageNoFlags);
    if (a_ret != kvImageNoError) return NULL;
    output_buffer.width = MAX(size.width, 0);
    output_buffer.height = MAX(size.height, 0);
    output_buffer.rowBytes = output_buffer.width * 4;
    output_buffer.data = malloc(output_buffer.rowBytes * output_buffer.height);
    if (!output_buffer.data) return NULL;
    
    vImage_Error ret = vImageScale_ARGB8888(&a_buffer, &output_buffer, NULL, kvImageHighQualityResampling);
    if (ret != kvImageNoError) return NULL;
    
    CGImageRef outputImage = vImageCreateCGImageFromBuffer(&output_buffer, &vImageFormatARGB8888, NULL, NULL, kvImageNoFlags, &ret);
    if (ret != kvImageNoError) return NULL;
    
    return outputImage;
}

+ (CGImageRef)croppedImageWithImage:(CGImageRef)aImage rect:(CGRect)rect
{
    vImage_Buffer a_buffer = {}, output_buffer = {};
    @onExit {
        if (a_buffer.data) free(a_buffer.data);
        if (output_buffer.data) free(output_buffer.data);
    };
    
    vImage_Error a_ret = vImageBuffer_InitWithCGImage(&a_buffer, &vImageFormatARGB8888, NULL, aImage, kvImageNoFlags);
    if (a_ret != kvImageNoError) return NULL;
    output_buffer.width = MAX(CGRectGetWidth(rect), 0);
    output_buffer.height = MAX(CGRectGetHeight(rect), 0);
    output_buffer.rowBytes = output_buffer.width * 4;
    output_buffer.data = malloc(output_buffer.rowBytes * output_buffer.height);
    if (!output_buffer.data) return NULL;
    
    // use translation to x & y axis and scale down output size, do not need resampling
    CGFloat tx = CGRectGetMinX(rect);
    CGFloat ty = CGRectGetMinY(rect);
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-tx, -ty);
    vImage_CGAffineTransform cg_transform = *((vImage_CGAffineTransform *)&transform);
    Pixel_8888 clear_color = {0};
    vImage_Error ret = vImageAffineWarpCG_ARGB8888(&a_buffer, &output_buffer, NULL, &cg_transform, clear_color, kvImageBackgroundColorFill);
    if (ret != kvImageNoError) return NULL;
    
    CGImageRef outputImage = vImageCreateCGImageFromBuffer(&output_buffer, &vImageFormatARGB8888, NULL, NULL, kvImageNoFlags, &ret);
    if (ret != kvImageNoError) return NULL;
    
    return outputImage;
}

+ (CGImageRef)flippedImageWithImage:(CGImageRef)aImage horizontal:(BOOL)horizontal
{
    vImage_Buffer a_buffer = {}, output_buffer = {};
    @onExit {
        if (a_buffer.data) free(a_buffer.data);
        if (output_buffer.data) free(output_buffer.data);
    };
    
    vImage_Error a_ret = vImageBuffer_InitWithCGImage(&a_buffer, &vImageFormatARGB8888, NULL, aImage, kvImageNoFlags);
    if (a_ret != kvImageNoError) return NULL;
    output_buffer.width = a_buffer.width;
    output_buffer.height = a_buffer.height;
    output_buffer.rowBytes = a_buffer.rowBytes;
    output_buffer.data = malloc(output_buffer.rowBytes * output_buffer.height);
    if (!output_buffer.data) return NULL;
    
    vImage_Error ret;
    if (horizontal) {
        ret = vImageHorizontalReflect_ARGB8888(&a_buffer, &output_buffer, kvImageHighQualityResampling);
    } else {
        ret = vImageVerticalReflect_ARGB8888(&a_buffer, &output_buffer, kvImageHighQualityResampling);
    }
    if (ret != kvImageNoError) return NULL;
    
    CGImageRef outputImage = vImageCreateCGImageFromBuffer(&output_buffer, &vImageFormatARGB8888, NULL, NULL, kvImageNoFlags, &ret);
    if (ret != kvImageNoError) return NULL;
    
    return outputImage;
}

+ (CGImageRef)rotatedImageWithImage:(CGImageRef)aImage radians:(CGFloat)radians
{
    vImage_Buffer a_buffer = {}, output_buffer = {};
    @onExit {
        if (a_buffer.data) free(a_buffer.data);
        if (output_buffer.data) free(output_buffer.data);
    };
    
    vImage_Error a_ret = vImageBuffer_InitWithCGImage(&a_buffer, &vImageFormatARGB8888, NULL, aImage, kvImageNoFlags);
    if (a_ret != kvImageNoError) return NULL;
    CGSize size = CGSizeMake(a_buffer.width, a_buffer.height);
    CGAffineTransform transform = CGAffineTransformMakeRotation(radians);
    size = CGSizeApplyAffineTransform(size, transform);
    output_buffer.width = ABS(size.width);
    output_buffer.height = ABS(size.height);
    output_buffer.rowBytes = output_buffer.width * 4;
    output_buffer.data = malloc(output_buffer.rowBytes * output_buffer.height);
    if (!output_buffer.data) return NULL;
    
    Pixel_8888 clear_color = {0};
    vImage_Error ret = vImageRotate_ARGB8888(&a_buffer, &output_buffer, NULL, radians, clear_color, kvImageBackgroundColorFill | kvImageHighQualityResampling);
    if (ret != kvImageNoError) return NULL;
    
    CGImageRef outputImage = vImageCreateCGImageFromBuffer(&output_buffer, &vImageFormatARGB8888, NULL, NULL, kvImageNoFlags, &ret);
    if (ret != kvImageNoError) return NULL;
    
    return outputImage;
}

+ (CGImageRef)shearedImageWithImage:(CGImageRef)aImage horizontal:(BOOL)horizontal offset:(CGVector)offset translation:(CGFloat)translation slope:(CGFloat)slope scale:(CGFloat)scale
{
    vImage_Buffer a_buffer = {}, output_buffer = {};
    @onExit {
        if (a_buffer.data) free(a_buffer.data);
        if (output_buffer.data) free(output_buffer.data);
    };
    
    vImage_Error a_ret = vImageBuffer_InitWithCGImage(&a_buffer, &vImageFormatARGB8888, NULL, aImage, kvImageNoFlags);
    if (a_ret != kvImageNoError) return NULL;
    output_buffer.width = MAX(a_buffer.width - offset.dx, 0);
    output_buffer.height = MAX(a_buffer.height - offset.dy, 0);
    output_buffer.rowBytes = output_buffer.width * 4;
    output_buffer.data = malloc(output_buffer.rowBytes * output_buffer.height);
    if (!output_buffer.data) return NULL;
    
    Pixel_8888 clear_color = {0};
    ResamplingFilter resampling_filter = vImageNewResamplingFilter(scale, kvImageHighQualityResampling);
    vImage_Error ret;
    if (horizontal) {
        ret = vImageHorizontalShear_ARGB8888(&a_buffer, &output_buffer, offset.dx, offset.dy, translation, slope, resampling_filter, clear_color, kvImageBackgroundColorFill);
    } else {
        ret = vImageVerticalShear_ARGB8888(&a_buffer, &output_buffer, offset.dx, offset.dy, translation, slope, resampling_filter, clear_color, kvImageBackgroundColorFill);
    }
    vImageDestroyResamplingFilter(resampling_filter);
    if (ret != kvImageNoError) return NULL;
    
    CGImageRef outputImage = vImageCreateCGImageFromBuffer(&output_buffer, &vImageFormatARGB8888, NULL, NULL, kvImageNoFlags, &ret);
    if (ret != kvImageNoError) return NULL;
    
    return outputImage;
}

+ (CGImageRef)affineTransformedImageWithImage:(CGImageRef)aImage transform:(CGAffineTransform)transform
{
    vImage_Buffer a_buffer = {}, output_buffer = {};
    @onExit {
        if (a_buffer.data) free(a_buffer.data);
        if (output_buffer.data) free(output_buffer.data);
    };
    
    vImage_Error a_ret = vImageBuffer_InitWithCGImage(&a_buffer, &vImageFormatARGB8888, NULL, aImage, kvImageNoFlags);
    if (a_ret != kvImageNoError) return NULL;
    CGSize size = CGSizeMake(a_buffer.width, a_buffer.height);
    size = CGSizeApplyAffineTransform(size, transform);
    output_buffer.width = ABS(size.width);
    output_buffer.height = ABS(size.height);
    output_buffer.rowBytes = output_buffer.width * 4;
    output_buffer.data = malloc(output_buffer.rowBytes * output_buffer.height);
    if (!output_buffer.data) return NULL;
    
    vImage_CGAffineTransform cg_transform = *((vImage_CGAffineTransform *)&transform);
    Pixel_8888 clear_color = {0};
    vImage_Error ret = vImageAffineWarpCG_ARGB8888(&a_buffer, &output_buffer, NULL, &cg_transform, clear_color, kvImageBackgroundColorFill | kvImageHighQualityResampling);
    if (ret != kvImageNoError) return NULL;
    
    CGImageRef outputImage = vImageCreateCGImageFromBuffer(&output_buffer, &vImageFormatARGB8888, NULL, NULL, kvImageNoFlags, &ret);
    if (ret != kvImageNoError) return NULL;
    
    return outputImage;
}

@end
