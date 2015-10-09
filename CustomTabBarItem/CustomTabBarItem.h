//
//  CustomTabBarItem.h
//  cocacolaOA
//
//  Created by mac on 13-8-21.
//
//

#import <UIKit/UIKit.h>


/**
 *  适用于7，8之后选中之后改变图片的需求
 */
@interface CustomTabBarItem : UITabBarItem
{
    UIImage  *customHighlightedImage;
}
@property (nonatomic, retain) UIImage *customHighlightedImage;
@end
