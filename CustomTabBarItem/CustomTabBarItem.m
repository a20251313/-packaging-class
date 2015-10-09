//
//  CustomTabBarItem.m
//  cocacolaOA
//
//  Created by mac on 13-8-21.
//
//

#import "CustomTabBarItem.h"

@implementation CustomTabBarItem
@synthesize customHighlightedImage;

-(UIImage *)selectedImage {

    return [self.customHighlightedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
- (UIImage *)unselectedImage{

    return self.image;
}
//-(UIImage*)finishedSelectedImage
//{
//    return self.customHighlightedImage;
//}

-(id)init
{
    self = [super init];
    if (self)
    {
      //  [self setTitlePositionAdjustment:UIOffsetMake(0, -2)];
      //  [self setImageInsets:UIEdgeInsetsMake(-3, 0, 2, 0)];
    }
    return self;
}




@end
