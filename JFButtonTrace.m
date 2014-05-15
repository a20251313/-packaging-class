//
//  JFButtonTrace.m
//  GuessImageWar
//
//  Created by ran on 14-2-12.
//  Copyright (c) 2014年 com.lelechat.GuessImageWar. All rights reserved.
//

#import "JFButtonTrace.h"


#define JFLabelTraceVIEWTAG 234512345
@implementation JFButtonTrace
@synthesize textFont;
@synthesize textTitle;
@synthesize textShadowColor;

- (id)initWithFrame:(CGRect)frame  withshadowColor:(UIColor*)shadowcolor withTextColor:(UIColor*)textColor title:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self)
    {
        JFLabelTrace    *labelTitle = [[JFLabelTrace alloc] initWithFrame:self.bounds withShadowColor:shadowcolor offset:CGSizeMake(1, 1) textColor:textColor];
        [labelTitle setText:title];
        [labelTitle setBackgroundColor:[UIColor clearColor]];
        [labelTitle setTextAlignment:NSTextAlignmentCenter];
        labelTitle.tag = JFLabelTraceVIEWTAG;
        [labelTitle setFont:TEXTFONTWITHSIZE(17)];
        [self addSubview:labelTitle];
        [labelTitle release];
    
        
        // Initialization code
    }
    return self;
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [self setTextTitle:title];
}

-(void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    [self setTextColor:color];
}

-(void)setTextFont:(UIFont *)newtextFont
{
    JFLabelTrace    *label = (JFLabelTrace*)[self viewWithTag:JFLabelTraceVIEWTAG];
    [label setFont:newtextFont];
}
-(void)setTextColor:(UIColor *)newtextColor
{
    JFLabelTrace    *label = (JFLabelTrace*)[self viewWithTag:JFLabelTraceVIEWTAG];
    [label setTextColor:newtextColor];
}


-(void)setTextTitle:(NSString *)newtextTitle
{
    JFLabelTrace    *label = (JFLabelTrace*)[self viewWithTag:JFLabelTraceVIEWTAG];
    [label setText:newtextTitle];
}

-(void)setTextShadowColor:(UIColor *)newtextShadowColor
{
    JFLabelTrace    *label = (JFLabelTrace*)[self viewWithTag:JFLabelTraceVIEWTAG];
    [label setShadowColor:newtextShadowColor];
    
}

-(NSString*)titleForState:(UIControlState)state
{
    JFLabelTrace    *label = (JFLabelTrace*)[self viewWithTag:JFLabelTraceVIEWTAG];
    return label.text;
}
-(void)dealloc
{
    self.textTitle = nil;
    self.textFont = nil;
    self.textColor = nil;
    [super dealloc];
}

-(UILabel*)titleLabel
{
    JFLabelTrace    *label = (JFLabelTrace*)[self viewWithTag:JFLabelTraceVIEWTAG];
    return label;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
