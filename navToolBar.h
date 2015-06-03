//
//  navToolBar.h
//  50jin
//
//  Created by jimmy on 14-2-12.
//  Copyright (c) 2014年 IRnovation. All rights reserved.
//

/*
 *  工具栏
 *  用于设备输入时，输入控件上方
 *  提供的功能有“上一项”，“下一项”，“完成”
 *  使用时要将需要激活的控件全部加入objects数组中
 *  并且设置好代理，（主要用于管理textfield）
 *  每次调用显示时，要设置正确的序列号
 */

#import <UIKit/UIKit.h>

@protocol toolbarEditDelegate <NSObject>

@optional

- (void)pressAmount;
- (void)pressPercent;
- (void)pressAverage;

@end

@interface navToolBar : UIToolbar

@property (nonatomic, weak) id<toolbarEditDelegate> myBarDelegate;

// 要对所有注册的对象进行管理
//@property (nonatomic, strong) NSArray* objects;
//@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UIBarButtonItem* amount;     //按金额
@property (nonatomic, strong) UIBarButtonItem* percent;    //按比率
@property (nonatomic, strong) UIBarButtonItem* average;    //均摊

// 根据当前激活控件在数组中的位置，刷新上一项和下一项的显示状态
- (void)refresh;            //刷新

@end
