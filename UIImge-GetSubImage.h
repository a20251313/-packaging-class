#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage(UIImageScale)  
- (UIImage*)getSubImage:(CGRect)rect;
+ (UIImage *)createGrayCopy:(UIImage *)source;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage *)reflectionWithHeight:(int)height;

+(UIImage*)getClearImage;
//crop image accord points array
+ (UIImage *)getCropImage:(UIImage *)image  point:(NSArray *)arrayPoint;
+ (UIImage *)getCropImage:(UIImage *)image  startAngel:(CGFloat)fStartAngel EndAngel:(CGFloat)fEndAngel;
+ (UIImage*)getScreenImageWithView:(UIView*)view  size:(CGSize)imageSize;
@end  