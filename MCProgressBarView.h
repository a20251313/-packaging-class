//
//  MCProgressBarView.h
//  MCProgressBarView
//
//  Created by Baglan on 12/29/12.
//  Copyright (c) 2012 MobileCreators. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImge-GetSubImage.h"

@interface MCProgressBarView : UIView

- (id)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage foregroundImage:(UIImage *)foregroundImage;

@property (nonatomic, assign) double progress;
@property (nonatomic,retain)UIImage *foreimage;


-(void)setForeViewAccordName:(NSString*)strName;


@end
