//
//  WLNavigationControlller.m
//  BizfocusOC
//
//  Created by jingfuran on 15/5/27.
//  Copyright (c) 2015年 郑东尧. All rights reserved.
//

#import "WLNavigationControlller.h"
#import "EPRootViewController.h"
@interface WLNavigationControlller ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation WLNavigationControlller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak WLNavigationControlller *weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        
    {
        
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        
        self.delegate = weakSelf;
        
    }
    
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated

{
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        
    {
        self.interactivePopGestureRecognizer.enabled = NO;
        EPRootViewController  *rootController = (EPRootViewController*)viewController;
        if ([rootController isKindOfClass:[EPRootViewController class
                                           ]])
        {
           
            self.navigationItem.leftBarButtonItem = [rootController createBackButtonItem];
            
            
        }
        
    }
        
    
    
    [super pushViewController:viewController animated:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationController:(UINavigationController *)navigationController

       didShowViewController:(UIViewController *)viewController

                    animated:(BOOL)animate

{
    
    // Enable the gesture again once the new controller is shown
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        
        self.interactivePopGestureRecognizer.enabled = YES;
    
    EPRootViewController  *rootController = (EPRootViewController*)viewController;
    if ([rootController isKindOfClass:[EPRootViewController class
                                       ]])
    {
        
        self.navigationItem.leftBarButtonItem = [rootController createBackButtonItem];
        
        
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
