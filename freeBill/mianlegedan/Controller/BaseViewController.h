//
//  BaseViewController.h
//  playboy
//
//  Created by 张梦川 on 15/11/5.
//  Copyright © 2015年 yaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUrl.h"
#import "UIImageView+WebCache.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

typedef enum {
    Network_None = 0,
    Network_2G = 1,
    Network_3G = 2,
    Network_4G = 3,
    Network_WIFI = 5,
}NetworkType;
@protocol mainViewDelegate <NSObject>

-(void)doclick;

@end
@interface BaseViewController : UIViewController
@property (nonatomic,weak)UILabel *navigationTitle;
@property (nonatomic, strong) UIImagePickerController *picker;
@property id<mainViewDelegate>delegate;

//////////////////////////////NetWork//////////////////////////////////////////////
//- (NetworkType) getNetworkTypeFromStatusBar;
//////////////////////////////message//////////////////////////////////////////////
- (void) showHUDmessage: (NSString *) message;
- (void) showHUDmessage: (NSString *) message withImage:(NSString *) imagePath;
- (void) showHUDmessage: (NSString *) message afterDelay:(NSTimeInterval) delay;
- (void) showHUDmessage: (NSString *) message withImage:(NSString *) imagePath afterDelay:(NSTimeInterval) delay;

- (void) startHUDmessage:(NSString *) message;
- (void) stopHUDmessage;
- (void) stopHUDmessageByAfterDelay:(NSTimeInterval) delay;
- (NSString *) md5:(NSString *)string;

- (BOOL)isEmpty:(NSString *)str;
//- (void) animateTextField: (UITextField*) textField up: (BOOL) up;
//- (void) animateTextView: (UITextView*) textField up: (BOOL) up;
- (void) alertMessage:(NSString *)str;
- (void) alert:(NSString *)str;
- (NSString *)imageWithUrl:(NSString *)imageName;
//- (NSString *)getDeviceIPIpAddresses;
- (void)uploadHeadImage;
-(void)goback;
@end
