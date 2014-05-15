//
//  MCProgressBarView.m
//  MCProgressBarView
//
//  Created by Baglan on 12/29/12.
//  Copyright (c) 2012 MobileCreators. All rights reserved.
//

#import "MCProgressBarView.h"

@implementation MCProgressBarView {
    UIImageView * _backgroundImageView;
    UIImageView * _foregroundImageView;
    CGFloat minimumForegroundWidth;
    CGFloat availableWidth;

}
@synthesize foreimage;

- (id)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage foregroundImage:(UIImage *)foregroundImage
{
    self = [super initWithFrame:frame];
    if (self)
    {
       backgroundImage   = [backgroundImage imageByScalingAndCroppingForSize:self.frame.size];
       foregroundImage = [foregroundImage imageByScalingAndCroppingForSize:self.frame.size];
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.image = backgroundImage;
        [self addSubview:_backgroundImageView];
        
        _foregroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _foregroundImageView.image = foregroundImage;
        [self addSubview:_foregroundImageView];
        
        UIEdgeInsets insets = foregroundImage.capInsets;
        minimumForegroundWidth = insets.left + insets.right;
        
        availableWidth = self.bounds.size.width - minimumForegroundWidth;
        
        self.foreimage = foregroundImage;
        self.progress = 0.5;
    }
    return self;
}

- (void)setProgress:(double)progress
{
    _progress = progress;
    
    CGRect frame = _foregroundImageView.frame;
    frame.size.width = self.frame.size.width*progress;//roundf(minimumForegroundWidth + availableWidth * progress);
    
    
   
   // [_foregroundImageView setFrame:frame];
    
    UIImage  *Image = [UIImage getCropImage:self.foreimage point:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0, 0)],[NSValue valueWithCGPoint:CGPointMake(0, frame.size.height)],[NSValue valueWithCGPoint:CGPointMake(frame.size.width, frame.size.height)],[NSValue valueWithCGPoint:CGPointMake(frame.size.width, 0)],nil]];
    _foregroundImageView.image = Image;
    
    
    
   // DLOG(@"progress :%f frame.size.width:%f self.width:%f Image.width:%f",progress,frame.size.width,self.frame.size.width,Image.size.width);
   // _foregroundImageView.frame = frame;
}



-(void)setForeViewAccordName:(NSString*)strName
{
    UIImage  *image = [UIImage imageNamed:strName];
    image = [image imageByScalingAndCroppingForSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    self.foreimage = image;
}

-(void)dealloc
{
    self.foreimage = nil;
    [_backgroundImageView release];
    _backgroundImageView = nil;
    [_foregroundImageView release];
    _foregroundImageView = nil;
    [super dealloc];
}

@end
