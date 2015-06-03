//
//  UITabBar+CustomBackground.m
//  cocacolaOA
//
//  Created by mac on 13-8-21.
//
//

#import "UITabBar+CustomBackground.h"

@implementation UITabBar (CustomBackground)

- (void)drawRect:(CGRect)rect{
    UIImage *image = [UIImage imageNamed:@"tarBar.png"];
    [image drawInRect:self.bounds];
}
- (void)customBackground{
    /*
    UIView *tabBarBgView = [[UIView alloc] initWithFrame:self.bounds];
    tabBarBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabBar.png"]];
    [self insertSubview:tabBarBgView atIndex:1];
     */
//    /*
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
       // [self setBarTintColor:[UIColor redColor]];
    }
    
    UIImageView *tabBarBgView = [[UIImageView alloc] initWithFrame:self.bounds];
    [tabBarBgView setImage:[UIImage imageNamed:@"tabBar.png"]];
    [tabBarBgView setContentMode:UIViewContentModeScaleToFill];
    [self insertSubview:tabBarBgView atIndex:1];
    
    
 
    
//    */
    
}
@end
