//
//  PublicClass.h
//  i366
//
//  Created by ran on 13-3-6.
//
//

#import <Foundation/Foundation.h>

@interface PublicClass : NSObject
+(UIImage *)getImageAccordName:(NSString *)ImageName;
+(UIImage *)getImage2point0AccordName:(NSString *)ImageName;
+(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize sourceImages:(UIImage*)images;
+(UIImage *)getImage2point0AccordBuddleFileName:(NSString *)ImageName;

//+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize sourceImages:(UIImage*)images;
@end
