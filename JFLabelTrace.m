//
//  JFLabelTrace.m
//  GuessImageWar
//
//  Created by ran on 14-2-12.
//  Copyright (c) 2014年 com.lelechat.GuessImageWar. All rights reserved.
//

#import "JFLabelTrace.h"

@implementation JFLabelTrace
@synthesize textShadowColor;
- (id)initWithFrame:(CGRect)frame withShadowColor:(UIColor*)shadowcolor offset:(CGSize)offset  textColor:(UIColor*)textColor
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.shadowColor = shadowcolor;
        self.shadowOffset = offset;
        self.textColor = textColor;
        [self setBackgroundColor:[UIColor clearColor]];
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    self.textShadowColor = nil;
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)setTextShadowColor:(UIColor *)newtextShadowColor
{
    self.shadowColor = newtextShadowColor;

}

-(void)drawTextInRect:(CGRect)rect
{
    
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 1);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = self.shadowColor;
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    self.shadowOffset = shadowOffset;
}

@end
