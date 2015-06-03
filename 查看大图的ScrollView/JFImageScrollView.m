//
//  JFImageScrollView.m
//  BizfocusOC
//
//  Created by jingfuran on 15/5/26.
//  Copyright (c) 2015年 郑东尧. All rights reserved.
//

#import "JFImageScrollView.h"
#import "UIImageView+WebCache.h"
#define kHasRequest     @"kHasRequest"
@interface JFImageScrollView ()<UIScrollViewDelegate>
{
    NSMutableArray  *m_arraySmallIds;
    NSMutableArray  *m_arrayBigIds;
    
    NSMutableDictionary *m_dicRequest;
    NSInteger       m_iCurrentIndex;
    UIScrollView    *m_scrollView;
}
@property(nonatomic,strong)NSString *picType;
@end

@implementation JFImageScrollView
@synthesize picType;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame smallIds:(NSArray*)smallIds bigIds:(NSArray*)bigIds index:(NSInteger)currentIndex type:(NSString*)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (smallIds.count != bigIds.count)
        {
            [NSException raise:@"JFImageScrollView init fail because Data" format:nil];
        }
        if (m_arraySmallIds == nil)
        {
            m_arraySmallIds = [[NSMutableArray alloc] init];
        }
        if (m_arrayBigIds == nil)
        {
            m_arrayBigIds = [[NSMutableArray alloc] init];
        }
        
        [m_arrayBigIds addObjectsFromArray:bigIds];
        [m_arraySmallIds addObjectsFromArray:smallIds];
        if (m_dicRequest == nil)
        {
            m_dicRequest = [[NSMutableDictionary alloc] init];
        }
        m_iCurrentIndex = currentIndex;
        self.picType = type;
        
        
        [self defaultInit];
        
    }
    return self;
}

-(void)defaultInit
{
    CGFloat  fwidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat  fheight = [[UIScreen mainScreen] bounds].size.height;
    if (m_scrollView == nil)
    {
        m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, fwidth, fheight)];
        [self addSubview:m_scrollView];
        m_scrollView.pagingEnabled = YES;
        m_scrollView.showsHorizontalScrollIndicator = NO;
        m_scrollView.showsVerticalScrollIndicator = NO;
        m_scrollView.delegate = self;
       
    }

    [self setBackgroundColor:[UIColor blackColor]];
    for (int i = 0;i < m_arraySmallIds.count;i++)
    {
        //NSString  *picId = [m_arraySmallIds[i] description];
        NSString  *bigPicId = [m_arraySmallIds[i] description];
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(fwidth*i, 0, fwidth, fheight)];
        view.tag = 234+i;
        [m_scrollView addSubview:view];

        if ([m_arraySmallIds[i] isKindOfClass:[UIImage class]])
        {
             [view setImage:(UIImage*)m_arraySmallIds[i]];
            
        }else
        {
             [view setSmallIDs:bigPicId type:self.picType];
        }
       
        view.userInteractionEnabled = YES;
        
//        UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHidden:)];
//        [view addGestureRecognizer:tap];
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaGesture:)];
        [view addGestureRecognizer:pinch];
        
        
    }
    
    UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHidden:)];
    [m_scrollView addGestureRecognizer:tap];
    
    [m_scrollView setContentSize:CGSizeMake(fwidth*m_arraySmallIds.count, fheight)];
    [m_scrollView setContentOffset:CGPointMake(m_iCurrentIndex*fwidth, 0)];
    
    [self refreshCurrentPage];
}



-(void)show
{
    UIWindow  *window  = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    [self setCenter:window.center];
    self.alpha = 0;
    [UIView animateWithDuration:0.35
                     animations:^{
                         self.alpha = 1;
                     } completion:^(BOOL finish){
                     }];
    
    [window makeKeyAndVisible];
}

-(void)clickHidden:(id)sendr
{
    self.alpha = 1;
    [UIView animateWithDuration:0.35
                     animations:^{
                         self.alpha = 0;
                     } completion:^(BOOL finish){
                         [self removeFromSuperview];
                     }];
}



-(void)refreshCurrentPage
{
    

    
    if (![m_dicRequest valueForKey:[@(m_iCurrentIndex) description]])
    {
        NSString  *bigPicId = [m_arraySmallIds[m_iCurrentIndex] description];
        UIImageView *view = (UIImageView*)[m_scrollView viewWithTag:234+m_iCurrentIndex];
        //  [view setPicIDs:bigPicId type:self.picType];
        if ([m_arraySmallIds[m_iCurrentIndex] isKindOfClass:[UIImage class]])
        {
            [view setImage:(UIImage*)m_arraySmallIds[m_iCurrentIndex]];
            
        }else
        {
            [view setPicIDs:bigPicId type:self.picType];
        }
        
        [m_dicRequest setObject:@"1" forKey:[@(m_iCurrentIndex) description]];
    }
    NSInteger  index = m_iCurrentIndex-1;
    if (index >= 0 && ![m_dicRequest valueForKey:[@(index) description]])
    {
        NSString  *bigPicId = [m_arraySmallIds[index] description];
        UIImageView *view = (UIImageView*)[m_scrollView viewWithTag:234+index];
        if ([m_arraySmallIds[index] isKindOfClass:[UIImage class]])
        {
            [view setImage:(UIImage*)m_arraySmallIds[index]];
            
        }else
        {
            [view setPicIDs:bigPicId type:self.picType];
        }
        [m_dicRequest setObject:@"1" forKey:[@(index) description]];
        
    }
    index = m_iCurrentIndex+1;
    if (index <= m_arraySmallIds.count-1 && ![m_dicRequest valueForKey:[@(index) description]])
    {
        NSString  *bigPicId = [m_arraySmallIds[index] description];
        UIImageView *view = (UIImageView*)[m_scrollView viewWithTag:234+index];
        if ([m_arraySmallIds[index] isKindOfClass:[UIImage class]])
        {
            [view setImage:(UIImage*)m_arraySmallIds[index]];
            
        }else
        {
            [view setPicIDs:bigPicId type:self.picType];
        }
        [m_dicRequest setObject:@"1" forKey:[@(index) description]];
        
    }

    
    UILabel *label = (UILabel*)[self viewWithTag:1023];
    if (label == nil)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 30)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:18]];
        [self addSubview:label];
        [label setTag:1023];
    }
    
    NSString  *string = [NSString stringWithFormat:@"%ld/%d",m_iCurrentIndex+1,m_arraySmallIds.count];
    [label setText:string];
    
}

#pragma mark GESTure
-(void)scaGesture:(UIPinchGestureRecognizer*)sender {
    
  
    CGFloat  lastScale = 1;
    //当手指离开屏幕时,将lastscale设置为1.0
    
    if([sender state] == UIGestureRecognizerStateEnded) {
        
        lastScale = 1.0;
        CGAffineTransform newTransform = CGAffineTransformMakeScale(1, 1);
        
        [[(UIPinchGestureRecognizer*)sender view]setTransform:newTransform];
        return;
        
    }
    
    
    
    CGFloat scale = sender.scale;
    if (scale > 2)
    {
        scale = 2;
    }else if(scale<0.5)
    {
        scale = 0.5;
    }

    
    CGAffineTransform newTransform = CGAffineTransformMakeScale(scale, scale);
    
    [[(UIPinchGestureRecognizer*)sender view] setTransform:newTransform];
    

    
}


- (void)scrollViewDidScroll:(UIScrollView *)myscrollView
{
    
    
    float targetX = myscrollView.contentOffset.x;
    int selectedIndex = floor(targetX / myscrollView.frame.size.width);
    if (selectedIndex < 0)
    {
        selectedIndex = 0;
    }
    
    if (selectedIndex > myscrollView.contentSize.width/myscrollView.frame.size.width-1)
    {
        selectedIndex = myscrollView.contentSize.width/myscrollView.frame.size.width-1;
    }
    
    m_iCurrentIndex = selectedIndex;
    [self refreshCurrentPage];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)myscrollView
{
  
    
    float targetX = myscrollView.contentOffset.x;
    int selectedIndex = floor(targetX / myscrollView.frame.size.width);
    if (selectedIndex < 0)
    {
        selectedIndex = 0;
    }
    
    if (selectedIndex > myscrollView.contentSize.width/myscrollView.frame.size.width-1)
    {
        selectedIndex = myscrollView.contentSize.width/myscrollView.frame.size.width-1;
    }
    
    m_iCurrentIndex = selectedIndex;
    [self refreshCurrentPage];
    
    
    
    
}

@end
