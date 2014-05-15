//
//  JFPlayAniManger.m
//  GuessImageWar
//
//  Created by ran on 14-1-6.
//  Copyright (c) 2014年 com.lelechat.GuessImageWar. All rights reserved.
//

#import "JFPlayAniManger.h"
#import "CABasicAnimation+someAniForProp.h"
#define TIME   0.75f

static JFPlayAniManger  *sharePlayAniManger = nil;

@implementation JFPlayAniManger

+(id)shareInstance
{
    if (!sharePlayAniManger)
    {
        sharePlayAniManger = [[JFPlayAniManger alloc] init];
    }
    
    return sharePlayAniManger;
}

-(void)addGoldWithAni:(int)goldNumber
{
    return;
    CGSize size =  CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);//[UIScreen mainScreen].bounds.size;
    UIView  *aniview = [JFPlayAniManger getViewAccordNumber:goldNumber imageType:JFGoldImageTypeAdd];
    CGPoint frompoint = CGPointMake(size.width/2, 180);
    CGPoint topoint = CGPointMake(size.width/2, 300);
    CABasicAnimation *aniop = [CABasicAnimation aninopacity:TIME name:nil];
    CABasicAnimation *anitran = [CABasicAnimation aniWithPosition:TIME fromValue:topoint tovalue:frompoint];
    [anitran setValue:aniview forKey:@"view"];
    anitran.delegate = self;
    
    UIWindow  *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    aniview.center = window.center;
    [window addSubview:aniview];
    
    [aniview.layer addAnimation:aniop forKey:nil];
    [aniview.layer addAnimation:anitran forKey:nil];
    
}
+(void)addGoldWithAni:(int)goldNumber
{
    if (goldNumber <= 0)
    {
        return;
    }
    
    JFPlayAniManger *manger = [JFPlayAniManger shareInstance];
    [manger addGoldWithAni:goldNumber];
}

+(void)deleteGoldWithAni:(int)goldNumber
{
    if (goldNumber <= 0)
    {
        return;
    }
    JFPlayAniManger *manger = [JFPlayAniManger shareInstance];
    [manger deleteGoldWithAni:goldNumber];
}
-(void)deleteGoldWithAni:(int)goldNumber
{
    return;
    CGSize size =  CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);//[UIScreen mainScreen].bounds.size;
    UIView  *aniview = [JFPlayAniManger getViewAccordNumber:goldNumber imageType:JFGoldImageTypeDelete];
    
    CGPoint frompoint = CGPointMake(size.width/2, 180);
    CGPoint topoint = CGPointMake(size.width/2, 300);
    CABasicAnimation *aniop = [CABasicAnimation aninopacity:TIME name:nil];
    CABasicAnimation *anitran = [CABasicAnimation aniWithPosition:TIME fromValue:frompoint tovalue:topoint];
    [anitran setValue:aniview forKey:@"view"];
    anitran.delegate = self;

    UIWindow  *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    aniview.center = window.center;
    [window addSubview:aniview];
    
    [aniview.layer addAnimation:aniop forKey:nil];
    [aniview.layer addAnimation:anitran forKey:nil];
    
}



- (void)animationDidStart:(CAAnimation *)anim
{
    
}

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    UIView  *view = [anim valueForKey:@"view"];
    [view removeFromSuperview];
    
}



+(UIView*)getViewAccordNumber:(int)goldNumber imageType:(JFGoldImageType)type
{
    
    //17
    UIView  *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSString   *strGold = [NSString stringWithFormat:@"%d",goldNumber];
    
    CGFloat fheight = 17;
    CGFloat fxpoint = 0;
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(fxpoint, (fheight-17)/2, 34, 17)];
    iconView.image = [UIImage imageNamed:@"goldchange_ani_goldicon.png"];
    [view addSubview:iconView];
    [iconView release];
    
    fxpoint += 34;
    if (type == JFGoldImageTypeAdd)
    {
        UIImageView *addView = [[UIImageView alloc] initWithFrame:CGRectMake(fxpoint, (fheight-10)/2, 10, 10)];
        addView.image = [UIImage imageNamed:@"goldchange_ani_add.png"];
        [view addSubview:addView];
        [addView release];
        fxpoint += 10;
    }else if (type == JFGoldImageTypeDelete)
    {
        UIImageView *deleteView = [[UIImageView alloc] initWithFrame:CGRectMake(fxpoint, (fheight-6)/2, 7, 6)];
        deleteView.image = [UIImage imageNamed:@"goldchange_ani_delete.png"];
        [view addSubview:deleteView];
        [deleteView release];
        fxpoint += 7;
    }
    
    for (int i = 0; i < [strGold length]; i++)
    {
        NSString    *strImageName = [NSString stringWithFormat:@"goldchange_ani%@.png",[strGold substringWithRange:NSMakeRange(i, 1)]];
        UIImage *image = [UIImage imageNamed:strImageName];
        if (!image)
        {
            DLOG(@"+++++++++++++getViewAccordNumber  error occur:%@",strImageName);
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(fxpoint, (fheight-image.size.height/2)/2, image.size.width/2, image.size.height/2)];
        imageView.image = image;
        [view addSubview:imageView];
        [imageView release];
        
        fxpoint += image.size.width/2;
    }
    
    [view setFrame:CGRectMake(0, 0, fxpoint, fheight)];
    return [view autorelease];
}
@end
