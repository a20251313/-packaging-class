//
//  MKTextBadgeView.h
//  TestBadgeView
//
//  Created by Akabeko on 11/08/Q28.
//  Copyright 2011年 Aabeko. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * iOS で使用されているバッジを模したコントロールです。
 */
@interface MKTextBadgeView : UIView
{
    NSString*       _value;	
	UIFont*         _font;
	UIColor*        _fillColor;
	UIColor*        _strokeColor;
	UIColor*        _textColor;
	NSUInteger      _padding;
	BOOL            _isUseShadow;
	BOOL            _isUseShine;
	NSTextAlignment _alignment;
}

/**
 * 表示するテキストを取得または設定します。
 */
@property (nonatomic, copy) NSString* value;

/**
 * 影を表示することを示す値を取得または設定します。
 */
@property (nonatomic, assign) BOOL isUseShadow;

/**
 * 光沢を使用することを示す値を取得または設定します。
 */
@property (nonatomic, assign) BOOL isUseShine;

/**
 * テキストのフォントを取得または設定します。
 */
@property (nonatomic, retain) UIFont* font;

/**
 * 背景の塗りつぶし色を取得または設定します。
 */
@property (nonatomic, retain) UIColor* fillColor;

/**
 * 枠線の色を取得または設定します。
 */
@property (nonatomic, retain) UIColor* strokeColor;

/**
 * テキストの色を取得または設定します。
 */
@property (nonatomic, retain) UIColor* textColor;

/**
 * テキストの表示位置を取得または設定します。
 */
@property (nonatomic, assign) NSTextAlignment alignment;

/**
 * バッジ内の余白を取得または設定します。
 */
@property (nonatomic, assign) NSUInteger padding;

/**
 * バッジのサイズを取得します。
 */
@property (nonatomic, readonly) CGSize badgeSize;

@end
