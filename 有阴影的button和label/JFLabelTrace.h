//
//  JFLabelTrace.h
//  GuessImageWar
//
//  Created by ran on 14-2-12.
//  Copyright (c) 2014年 com.lelechat.GuessImageWar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFLabelTrace : UILabel
- (id)initWithFrame:(CGRect)frame withShadowColor:(UIColor*)shadowcolor offset:(CGSize)offset  textColor:(UIColor*)textColor;
@property(nonatomic,retain)UIColor  *textShadowColor;
@end
