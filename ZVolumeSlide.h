//
//  ZVolumeSlide.h
//  AppTestSlide
//
//  Created by ZStart on 13-8-16.
//  Copyright (c) 2013年 ZStart. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZVolumeSlide;
@protocol ZVolumeSlideDelegate <NSObject>

- (void) slideValueChange:(CGFloat) value;

@end
@interface ZVolumeSlide : UIView{
    
    UISlider    *_slideView;
    UIView      *_processView;
    CGFloat     width;
    CGFloat     height;
    id<ZVolumeSlideDelegate>_delegate;
}
@property (assign, nonatomic) id<ZVolumeSlideDelegate>delegate;
@property (retain, nonatomic) UISlider  *slideView;
@property (retain, nonatomic) UIView    *processView;

- (void) setSlideValue:(CGFloat) value;
- (void) slideValueChanged;
-(void)setThumaImage:(UIImage*)image;
-(CGFloat)value;


- (id)initWithFrame:(CGRect)frame withBgImage:(UIImage*)bgImage foreGroundImage:(UIImage*)foreImage;
-(void)setSizeSliderYpoint:(CGFloat)fYpoint;
@end
