//
//  JFImageScrollView.h
//  BizfocusOC
//
//  Created by jingfuran on 15/5/26.
//  Copyright (c) 2015年 郑东尧. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFImageScrollView : UIView


-(void)show;
-(id)initWithFrame:(CGRect)frame smallIds:(NSArray*)smallIds bigIds:(NSArray*)bigIds index:(NSInteger)currentIndex type:(NSString*)type;
@end
