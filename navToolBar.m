//
//  navToolBar.m
//  50jin
//
//  Created by jimmy on 14-2-12.
//  Copyright (c) 2014年 IRnovation. All rights reserved.
//

#import "navToolBar.h"

@implementation navToolBar

@synthesize myBarDelegate;
@synthesize amount;
@synthesize percent;
@synthesize average;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initBtns];
        [self refresh];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)initBtns
{
    // items 上一项按钮
    UIButton  *btnamount = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 30)];
    [btnamount setBackgroundImage:[UIImage imageNamed:@"btn_amount_icon"] forState:UIControlStateNormal];
    [btnamount addTarget:self action:@selector(pressAmountBtn:) forControlEvents:UIControlEventTouchUpInside];
    amount = [[UIBarButtonItem alloc] initWithCustomView:btnamount];
    
    // 下一项按钮
    UIButton  *btnpercent = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 30)];
    [btnpercent setBackgroundImage:[UIImage imageNamed:@"btn_percent_icon"] forState:UIControlStateNormal];
    [btnpercent addTarget:self action:@selector(pressPercentBtn:) forControlEvents:UIControlEventTouchUpInside];
    percent = [[UIBarButtonItem alloc] initWithCustomView:btnpercent];
    
    // 可伸缩的UI控件，用于完成按钮的右对齐
    UIBarButtonItem* flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    // 完成按钮
    
    UIButton  *btnaverage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 30)];
    [btnaverage setBackgroundImage:[UIImage imageNamed:@"btn_average_icon"] forState:UIControlStateNormal];
    [btnaverage addTarget:self action:@selector(pressAverageBtn:) forControlEvents:UIControlEventTouchUpInside];
    average = [[UIBarButtonItem alloc] initWithCustomView:btnaverage];
    
    [self setItems:@[amount, percent, flex, average]];
    
    [self setBackgroundColor:[UIColor grayColor]];
    
    // 这里将激活控件的index设置为0（第一项）
    //self.index = 0;
}

- (void) pressAmountBtn:(id)sender
{
    // 自定义事件
    if (self.myBarDelegate && [self.myBarDelegate respondsToSelector:@selector(pressAmount)]) {
        [self.myBarDelegate pressAmount];
    }
    
    
    [self refresh];
}

- (void) pressPercentBtn:(id)sender
{
    // 自定义事件
    if (self.myBarDelegate && [self.myBarDelegate respondsToSelector:@selector(pressPercent)]) {
        [self.myBarDelegate pressPercent];
    }
    
    [self refresh];
}

- (void) pressAverageBtn:(id)sender
{
    // 自定义事件
    if (self.myBarDelegate && [self.myBarDelegate respondsToSelector:@selector(pressAverage)]) {
        [self.myBarDelegate pressAverage];
    }
    

    
}

// 根据当前激活控件在数组中的位置，刷新上一项和下一项的显示状态
- (void)refresh
{
//    if (self.index <= 0) {
//        [self.pre setEnabled:NO];
//    }else{
//        [self.pre setEnabled:YES];
//    }
//    
//    if (self.index >= [self.objects count]-1) {
//        [self.next setEnabled:NO];
//    }else{
//        [self.next setEnabled:YES];
//    }
//    
}

@end
