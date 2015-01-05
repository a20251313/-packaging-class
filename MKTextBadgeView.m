//
//  MKTextBadgeView.m
//  TestBadgeView
//
//  Created by Akabeko on 11/08/28.
//  Copyright 2011年 Akabeko. All rights reserved.
//

#import "MKTextBadgeView.h"

@interface MKTextBadgeView()
- (CGPoint)calcCtmPoint:(CGRect)rect;
- (CGPathRef)createBadgePathForTextSize:(CGSize)size;
- (void)drawShadow:(CGContextRef)context badgePath:(CGPathRef)path;
- (void)drawShhine:(CGContextRef)context badgeRect:(CGRect)rect badgePath:(CGPathRef)path;
- (void)initState;
@end

@implementation MKTextBadgeView

@synthesize value       = _value;
@synthesize isUseShadow = _isUseShadow;
@synthesize isUseShine  = _isUseShine;
@synthesize font        = _font;
@synthesize fillColor   = _fillColor;
@synthesize strokeColor = _strokeColor;
@synthesize textColor   = _textColor;
@synthesize alignment   = _alignment;
@synthesize padding     = _padding;
@dynamic    badgeSize;

/**
 * インスタンスを初期化します。
 *
 * @param frame 矩形情報。
 *
 * @return 初期化されたインスタンス。
 */
- (id)initWithFrame:(CGRect)frame 
{
    if( self = [super initWithFrame:frame] )
    {
        [self initState];
    }
  
    return self;
}

/**
 * インスタンスを初期化します。
 *
 * @param decoder シリアライザ。
 *
 * @return 初期化されたインスタンス。
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super initWithCoder:decoder] )
    {
        [self initState];
    }

    return self;
}

/**
 * 確保したメモリを解放します。
 */
- (void)dealloc 
{
    #if !__has_feature(objc_arc)
    [_font        release];
    [_fillColor   release];
    [_strokeColor release];
    [_textColor   release];
    [_value       release];

    [super dealloc];
    #endif
}



-(CGSize)getHeightOfFont:(UIFont*)aFont text:(NSString*)aStr
{
    
    CGSize aSize = CGSizeZero;
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:aFont, NSFontAttributeName,nil];
        
    aSize = [aStr sizeWithAttributes:tdic];
    
    return aSize;
}
/**
 * 描画を行います。
 *
 * @param rect 描画領域となる矩形。
 */
- (void)drawRect:(CGRect)rect 
{
    CGContextRef context   = UIGraphicsGetCurrentContext();
    CGSize       size      = [self getHeightOfFont:self.font text:self.value];
    CGPathRef    path      = [self createBadgePathForTextSize:size];

    rect = CGPathGetBoundingBox( path );
    rect.origin.x    = 0;
    rect.origin.y    = 0;
    rect.size.width  = ceil( rect.size.width  );
    rect.size.height = ceil( rect.size.height );

    CGContextSaveGState( context );
    CGContextSetLineWidth( context, 2.0 );
    CGContextSetStrokeColorWithColor( context, self.strokeColor.CGColor );
    CGContextSetFillColorWithColor( context, self.fillColor.CGColor );

    CGPoint ctm = [self calcCtmPoint:rect];
    CGContextTranslateCTM( context, ctm.x, ctm.y );

    // 影
    if( self.isUseShadow )
    {
      
        [self drawShadow:context badgePath:path];
       
    }
    CGContextBeginPath( context );
    CGContextAddPath( context, path );
    CGContextClosePath( context );
    CGContextDrawPath( context, kCGPathFillStroke );
    

 

    // 光沢
    if( self.isUseShine ) { [self drawShhine:context badgeRect:rect badgePath:path]; }

    CGContextRestoreGState( context );
    CGPathRelease( path );

    CGContextSaveGState( context );
    CGContextSetFillColorWithColor( context, self.textColor.CGColor );

    CGPoint point = CGPointMake( ctm.x + ( rect.size.width - size.width ) / 2, ctm.y + ( rect.size.height - size.height ) / 2 );
     NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName,nil];
     [self.value drawAtPoint:point withAttributes:tdic];

    CGContextRestoreGState( context );
}

#pragma mark - Property methods

/**
 * バッジのサイズをを取得します。
 *
 * @return サイズ。
 */
- (CGSize)badgeSize
{
	CGSize    size = [self getHeightOfFont:self.font text:self.value];
	CGPathRef path = [self createBadgePathForTextSize:size];
	CGRect    rect = CGPathGetBoundingBox( path );

	rect.origin.x    = 0;
	rect.origin.y    = 0;
	rect.size.width  = ceil( rect.size.width  );
	rect.size.height = ceil( rect.size.height );

	CGPathRelease( path );

	return rect.size;
}

#pragma mark - Private methods

/**
 * バッジの描画位置を取得します。
 *
 * @param rect    バッジの矩形。
 *
 * @return 位置。
 */
- (CGPoint)calcCtmPoint:(CGRect)rect
{
    CGRect  bounds = self.bounds;
    CGPoint ctm;

    switch( self.alignment )
    {
        default:
        case NSTextAlignmentCenter:
            ctm = CGPointMake( round( ( bounds.size.width - rect.size.width ) / 2 ), round( ( bounds.size.height - rect.size.height ) / 2 ) );
            break;

        case NSTextAlignmentLeft:
            ctm = CGPointMake( 4, round( ( bounds.size.height - rect.size.height ) / 2 ) );
            break;

        case NSTextAlignmentRight:
            ctm = CGPointMake( ( bounds.size.width - rect.size.width ) - 4, round( ( bounds.size.height - rect.size.height ) / 2 ) );
            break;
    }

    return ctm;
}

/**
 * テキストのパスを生成します。
 *
 * @param size 基準サイズ。
 *
 * @return パス。
 */
- (CGPathRef)createBadgePathForTextSize:(CGSize)size
{
	const CGFloat kPi = 3.14159265;
	
	CGFloat radius     = ceil( ( size.height + self.padding ) / 2.0 );
	CGFloat adjustment = size.width - size.height / 2.0;
	CGFloat width      = 2.0 * radius;

	if( adjustment > 0.0 )
	{
		width += adjustment;
	}else
	{
//		adjustment = 0;
	}
	
	CGMutablePathRef path = CGPathCreateMutable();
	
	CGPathMoveToPoint( path, NULL, radius, 0 );
	CGPathAddArc( path, NULL, radius, radius, radius, 3.0 * kPi / 2.0, kPi / 2.0, YES );
	CGPathAddLineToPoint( path, NULL, width - radius, 2.0 * radius );
	CGPathAddArc( path, NULL, width - radius, radius, radius, kPi / 2.0, 3.0 * kPi / 2.0, YES );
	CGPathAddLineToPoint( path, NULL, radius, 0 );
	
	return path;
}

/**
 * 影を描画します。
 *
 * @param context 描画コンテキスト。
 * @param path    バッジのパス。
 */
- (void)drawShadow:(CGContextRef)context badgePath:(CGPathRef)path
{
    CGContextSaveGState( context );

    CGSize   size  = CGSizeMake( 0, 1 );
    UIColor* color = [[UIColor blackColor] colorWithAlphaComponent:0.5];

    CGContextSetShadowWithColor( context, size, 4, color.CGColor );

    CGContextBeginPath( context );
    CGContextAddPath( context, path );
    CGContextClosePath( context );

    CGContextDrawPath( context, kCGPathFillStroke );
    CGContextRestoreGState( context );
}

/**
 * 光沢を描画します。
 *
 * @param context 描画コンテキスト。
 * @param rect    バッジの矩形。
 * @param path    バッジのパス。
 */
- (void)drawShhine:(CGContextRef)context badgeRect:(CGRect)rect badgePath:(CGPathRef)path
{
    CGContextBeginPath( context );
    CGContextAddPath( context, path );
    CGContextClosePath( context );
    CGContextClip( context );
    
    CGColorSpaceRef colorSpace      = CGColorSpaceCreateDeviceRGB();
    CGFloat         components[ 8 ] = { 1, 1, 1, 0.8, 1, 1, 1, 0 };
    CGFloat         locations[ 2 ]  = { 0, 1 };
    CGGradientRef   gradient        = CGGradientCreateWithColorComponents( colorSpace, components, locations, 2 );

    CGContextSaveGState( context );
    CGContextBeginPath( context );
    CGContextMoveToPoint( context, 0, 0 );
    
    CGFloat startY = rect.size.height * 0.25;
    CGFloat stopY  = startY + rect.size.height * 0.4;

    CGContextAddLineToPoint( context, 0, startY );
    CGContextAddCurveToPoint( context, 0, stopY, rect.size.width, stopY, rect.size.width, startY );
    CGContextAddLineToPoint( context, rect.size.width, 0 );
    CGContextClosePath( context );
    CGContextClip( context );
    CGContextDrawLinearGradient( context, gradient, CGPointMake( rect.size.width / 2.0, 0 ), CGPointMake( rect.size.width / 2.0, stopY ), kCGGradientDrawsBeforeStartLocation );
    CGContextRestoreGState( context );
    
    CGColorSpaceRelease( colorSpace );
    CGGradientRelease( gradient );
}

/**
 * インスタンスの状態を初期化します。
 */
- (void)initState;
{	
	self.opaque          = NO;
	self.backgroundColor = [UIColor clearColor];

	self.padding     = 1;
	self.font        = [UIFont boldSystemFontOfSize:11];
	self.isUseShadow = YES;
	self.isUseShine  = YES;
	self.alignment   = NSTextAlignmentCenter;
	self.fillColor   = [UIColor redColor];
	self.strokeColor = [UIColor whiteColor];
	self.textColor   = [UIColor whiteColor];
}

@end



