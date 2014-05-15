//
//  JFAlertView.h
//  i366
//
//  Created by ran on 13-7-12.
//
//

#import <UIKit/UIKit.h>
#import "JFButtonTrace.h"
@class JFAlertView;

typedef enum
{
    JFAlertViewClickIndexNone = -1,
    JFAlertViewClickIndexLeft = 0,
    JFAlertViewClickIndexRight,
    JFAlertViewClickIndexRemove
}JFAlertViewClickIndex;


@protocol JFAlertViewDeledate <NSObject>
@optional
-(void)JFAlertClickView:(JFAlertView *)alertView index:(JFAlertViewClickIndex)buttonIndex;
- (void)dismissWithClickedButtonIndex:(JFAlertViewClickIndex)buttonIndex animated:(BOOL)animated;
@end


@interface JFAlertView : UIView
{
    
    
    
    BOOL        m_bIsWillRemove;
    UIImageView *_backgroundImageView;
    JFLabelTrace     *_contentLabel;
    
    JFButtonTrace    *_rightButton;
    JFButtonTrace    *_leftButton;
    
    UIView      *_overlayView;
    
    id<JFAlertViewDeledate>   delegate;
}
@property(nonatomic,assign)id<JFAlertViewDeledate>  delegate;
@property(nonatomic,copy)NSString  *leftTitle;
@property(nonatomic,copy)NSString  *RightTitle;
@property(nonatomic,copy)NSString  *prompt;
@property(nonatomic,copy)NSString  *warningMsg;
@property(nonatomic)JFAlertViewClickIndex cancelButtonIndex;
@property(nonatomic)JFAlertViewClickIndex leftButtonIndex;
@property(nonatomic)JFAlertViewClickIndex rightButtonIndex;


-(id)initWithTitle:(NSString *)strPrompt  message:(NSString *)strMsg  delegate:(id<JFAlertViewDeledate>)Jfdelegate cancelButtonTitle:(NSString *)strLeft otherButtonTitles:(NSString *)strRight;
- (void)show;
- (void)dismiss;
-(void)addCloseButton;

@end
