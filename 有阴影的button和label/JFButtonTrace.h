//
//  JFButtonTrace.h
//  GuessImageWar
//
//  Created by ran on 14-2-12.
//  Copyright (c) 2014年 com.lelechat.GuessImageWar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFLabelTrace.h"
@interface JFButtonTrace : UIButton
- (id)initWithFrame:(CGRect)frame  withshadowColor:(UIColor*)shadowcolor withTextColor:(UIColor*)textColor title:(NSString*)title;

@property(nonatomic,retain)UIFont   *textFont;
@property(nonatomic,retain)UIColor  *textColor;
@property(nonatomic,retain)UIColor  *textShadowColor;
@property(nonatomic,retain)NSString *textTitle;
@end
