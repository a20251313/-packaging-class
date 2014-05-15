//
//  ZVolumeSlide.m
//  AppTestSlide
//
//  Created by ZStart on 13-8-16.
//  Copyright (c) 2013年 ZStart. All rights reserved.
//

#import "ZVolumeSlide.h"
#import "UIImge-GetSubImage.h"
@implementation ZVolumeSlide
@synthesize slideView = _slideView;
@synthesize processView = _processView;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [_processView release];
    [_slideView release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame withBgImage:(UIImage*)bgImage foreGroundImage:(UIImage*)foreImage
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor]; //背景颜色设置，设置为clearColor 背景透明
        
        
        width = frame.size.width;
        height= frame.size.height;
        
        UIView *view = [[UIView alloc]initWithFrame:self.bounds];
        bgImage = [bgImage imageByScalingAndCroppingForSize:frame.size];
        view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
        [self addSubview:view];
        [view release];
        
        
        
        _processView = [[UIView alloc]init];
        foreImage = [foreImage imageByScalingAndCroppingForSize:frame.size];
        _processView.backgroundColor = [UIColor colorWithPatternImage:foreImage];
        _processView.frame = CGRectMake(0, 0, width, height);
        
        [self addSubview:_processView];
        
        _slideView = [[UISlider alloc]initWithFrame:CGRectMake(0, -height, width, height)];
        _slideView.value = 0;
        
        _slideView.maximumValue = 1.0;
        _slideView.minimumValue = 0.0;
        
        [_slideView setMaximumTrackImage:[UIImage imageNamed:@"clearBack.png"] forState:UIControlStateNormal];
        [_slideView setMinimumTrackImage:[UIImage imageNamed:@"clearBack.png"] forState:UIControlStateNormal];
        
        [_slideView addTarget:self action:@selector(slideValueChanged) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_slideView];
    }
    return self;
}


-(void)setSizeSliderYpoint:(CGFloat)fYpoint
{
    [_slideView setFrame:CGRectMake(0, fYpoint, width, height)];
}

-(void)setThumaImage:(UIImage*)image
{
    
 //   image = [image imageByScalingAndCroppingForSize:CGSizeMake(image.size.width/2, image.size.height/2)];
    [_slideView setThumbImage:image forState:UIControlStateNormal];
}

-(CGFloat)value
{
    return _slideView.value;
}
- (void) setSlideValue:(CGFloat) value{
    _slideView.value = value;
    [self slideValueChanged];
}
- (void) slideValueChanged{
    CGFloat value = _slideView.value;
    _processView.frame = CGRectMake(0, 0, width * value, height);
    [_delegate slideValueChange:_slideView.value];
}
@end
