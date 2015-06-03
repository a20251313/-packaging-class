//
//  UINavigationBar+BackgroundImage.m
//  cocacolaOA
//
//  Created by mac on 13-8-20.
//
//

#import "UINavigationBar+BackgroundImage.h"

@implementation UINavigationBar (BackgroundImage)

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    UIImage *image = [UIImage imageNamed:@"NavBar.png"];
    [image drawInRect:rect];
}
- (void)setCustomizeImage
{
    if([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        //iOS 5 new UINavigationBar custom background
        [self setBackgroundImage:[UIImage imageNamed:@"NavBar.png"] forBarMetrics: UIBarMetricsDefault];
    } else {
        NSString *barBgPath = [[NSBundle mainBundle] pathForResource:@"NavBar" ofType:@"png"];
        [self.layer setContents: (id)[UIImage imageWithContentsOfFile: barBgPath].CGImage];
    }
}


@end
