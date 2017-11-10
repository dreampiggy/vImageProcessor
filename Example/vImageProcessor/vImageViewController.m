//
//  vImageViewController.m
//  vImageProcessor
//
//  Created by dreampiggy on 11/10/2017.
//  Copyright (c) 2017 dreampiggy. All rights reserved.
//

#import "vImageViewController.h"
#import "UIViewAdditions.h"
#import <vImageProcessor/UIImage+vImageProcess.h>

@interface vImagePreviewView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *title;

@end

@implementation vImagePreviewView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.imageView = [UIImageView new];
    self.title = [UILabel new];
    [self addSubview:self.imageView];
    [self addSubview:self.title];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.title.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.title sizeToFit];
    self.title.bottom = self.height;
    self.title.centerX = self.centerX;
    self.imageView.top = 0;
    self.imageView.left = 0;
    self.imageView.height = self.height - self.title.height;
    self.imageView.width = self.width;
}

@end


@interface vImageViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation vImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView = [UIScrollView new];
    self.scrollView.contentSize = self.scrollView.size;
    [self.view addSubview:self.scrollView];
    
    UIImage *testImage = [UIImage imageNamed:@"TestImageLarge"];
    UIImage *blendImage = [UIImage imageNamed:@"TestImage"];
    
    vImagePreviewView *view1 = [vImagePreviewView new];
    [self.scrollView addSubview:view1];
    view1.imageView.image = testImage;
    view1.title.text = @"Original";
    
    vImagePreviewView *view2 = [vImagePreviewView new];
    [self.scrollView addSubview:view2];
    view2.imageView.image = [testImage vImage_alphaBlendedImageWithColor:[UIColor colorWithWhite:1 alpha:0.5]];
    view2.title.text = @"Alpha Blend Color";
    
    vImagePreviewView *view3 = [vImagePreviewView new];
    [self.scrollView addSubview:view3];
    view3.imageView.image = [testImage vImage_alphaBlendedImageWithImage:blendImage];
    view3.title.text = @"Alpha Blend Image";
    
    vImagePreviewView *view4 = [vImagePreviewView new];
    [self.scrollView addSubview:view4];
    view4.imageView.image = [testImage vImage_scaledImageWithSize:CGSizeMake(300, 400)];
    view4.title.text = @"Scale";
    
    vImagePreviewView *view5 = [vImagePreviewView new];
    [self.scrollView addSubview:view5];
    view5.imageView.image = [testImage vImage_croppedImageWithRect:CGRectMake(0, 0, 1000, 1000)];
    view5.title.text = @"Crop";
    
    vImagePreviewView *view6 = [vImagePreviewView new];
    [self.scrollView addSubview:view6];
    view6.imageView.image = [testImage vImage_shearedImageWithHorizontal:YES offset:CGVectorMake(0, 0) translation:0 slope:M_PI_4 scale:0.5];
    view6.title.text = @"Shear";
    
    vImagePreviewView *view7 = [vImagePreviewView new];
    [self.scrollView addSubview:view7];
    view7.imageView.image = [testImage vImage_flippedImageWithHorizontal:YES];
    view7.title.text = @"Flip";
    
    vImagePreviewView *view8 = [vImagePreviewView new];
    [self.scrollView addSubview:view8];
    view8.imageView.image = [testImage vImage_rotatedImageWithRadians:M_PI_2];
    view8.title.text = @"Rotate";
    
    vImagePreviewView *view9 = [vImagePreviewView new];
    [self.scrollView addSubview:view9];
    view9.imageView.image = [testImage vImage_affineTransformedImageWithTransform:CGAffineTransformScale(CGAffineTransformMakeTranslation(100, 0), 0.5, 1)];
    view9.title.text = @"Affine Transform";
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
    CGFloat height = 0;
    CGFloat length = MIN(CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    NSUInteger index = 0;
    for (UIView * view in self.scrollView.subviews) {
        if ([view isKindOfClass:[vImagePreviewView class]]) {
            CGRect frame = CGRectMake(0, length * index, length, length);
            view.frame = frame;
            index++;
            height += length;
        }
    }
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
