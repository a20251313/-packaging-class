//
//  PublicClass.m
//  i366
//
//  Created by ran on 13-3-6.
//
//

#import "PublicClass.h"

@implementation PublicClass


/*!
 *  @author
 *          jingfu Ran
 *  @since
 *          2012 06 06
 *  @brief
 *           copy from website
 *           scale the image.
 *  @param
 *           targetSize
 *              The size you wanna
 *  @param
 *            images
 *               source image
 *	@return
 *           UIImage
 *
 */
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize sourceImages:(UIImage*)images
{
  /*  UIImage *newImage = nil;
    // NSAutoreleasePool  *pool = [[NSAutoreleasePool alloc] init];
    UIImage *sourceImage = images;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    // [newImage retain];
    //[pool drain];
    return newImage;*/
    
    

    UIGraphicsBeginImageContextWithOptions(targetSize,0,2);
    [images drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage *originImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return originImage;
    
}

+(UIImage *)getImageAccordName:(NSString *)ImageName
{
    
    if (ImageName ==nil || [ImageName length] < 2)
    {
        return nil;
    }
    NSString  *strPathfile = [[NSBundle mainBundle] pathForResource:ImageName ofType:nil];
    if (strPathfile == nil)
    {
        ImageName = [ImageName stringByReplacingOccurrencesOfString:@".png" withString:@""];
        ImageName = [ImageName stringByAppendingString:@"@2x"];
        strPathfile = [[NSBundle mainBundle] pathForResource:ImageName ofType:@"png"];
    }
    

    NSData  *data = [NSData dataWithContentsOfFile:strPathfile];
    
    if (strPathfile == nil  || data == nil)
    {
        DLOG(@"\n\n\n\n\n++++++++++error occours :%@ data:%@  imageName:%@\n\n\n\n\n\n",strPathfile,data,ImageName);
    }
    
    UIImage *image =  [UIImage imageWithData:data];
    
       
    if ([ImageName rangeOfString:@"@2x"].location  != NSNotFound)
    {
        image = [PublicClass imageByScalingAndCroppingForSize:CGSizeMake(image.size.width/2, image.size.height/2) sourceImages:image];
    }
    
    return image;
}


+(UIImage *)getImage2point0AccordName:(NSString *)ImageName
{
   /* NSString  *strPathfile = [[NSBundle mainBundle] pathForResource:ImageName ofType:nil];
    if (strPathfile == nil)
    {
        ImageName = [ImageName stringByReplacingOccurrencesOfString:@".png" withString:@""];
        ImageName = [ImageName stringByAppendingString:@"@2x"];
        strPathfile = [[NSBundle mainBundle] pathForResource:ImageName ofType:@"png"];
    }*/
    
    
    NSData  *data = [NSData dataWithContentsOfFile:ImageName];
    
    if (data == nil)
    {
      //  DLOG(@"\n\n\n\n\n++++++++++error occours :%@ data:%@  imageName:%@\n\n\n\n\n\n",strPathfile,data,ImageName);
        return nil;
    }
    
    UIImage *image =  [UIImage imageWithData:data];
    
    if (image.scale < 2)
    {
        image = [PublicClass imageByScalingAndCroppingForSize:CGSizeMake(image.size.width, image.size.height) sourceImages:image];
    }
    
    
    return image;
}


+(UIImage *)getImage2point0AccordBuddleFileName:(NSString *)ImageName
{
     NSString  *strPathfile = [[NSBundle mainBundle] pathForResource:ImageName ofType:nil];
     if (strPathfile == nil)
     {
         ImageName = [ImageName stringByReplacingOccurrencesOfString:@".png" withString:@""];
         ImageName = [ImageName stringByAppendingString:@"@2x"];
         strPathfile = [[NSBundle mainBundle] pathForResource:ImageName ofType:@"png"];
     }
    
    
    NSData  *data = [NSData dataWithContentsOfFile:strPathfile];
    
    if (data == nil)
    {
        //  DLOG(@"\n\n\n\n\n++++++++++error occours :%@ data:%@  imageName:%@\n\n\n\n\n\n",strPathfile,data,ImageName);
        return nil;
    }
    
    UIImage *image =  [UIImage imageWithData:data];
    
    if (image.scale < 2)
    {
         image = [PublicClass imageByScalingAndCroppingForSize:CGSizeMake(image.size.width, image.size.height) sourceImages:image];
    }
    
   
    
    
    return image;
}

@end
