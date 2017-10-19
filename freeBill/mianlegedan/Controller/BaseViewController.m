//
//  BaseViewController.m
//  playboy
//
//  Created by 张梦川 on 15/11/5.
//  Copyright © 2015年 yaoyu. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>
#import <AVFoundation/AVFoundation.h>
@interface BaseViewController ()<MBProgressHUDDelegate>

@end

@implementation BaseViewController{
     MBProgressHUD *progressHUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 0);
    [leftButton setFrame:CGRectMake(0, 0, 50, 30)];
    [leftButton addTarget:self
                   action:@selector(goback)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (NSString *)imageWithUrl:(NSString *)imageName{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",IMGURL,imageName];
    return url;
}

// 返回按钮
-(void)goback{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//////////////////////////////netWork//////////////////////////////////////////////
//判断网路类型
//- (NetworkType) getNetworkTypeFromStatusBar {
//    
//    UIApplication *app = [UIApplication sharedApplication];
//    
//    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
//    
//    NSNumber *dataNetworkItemView = nil;
//    for (id subview in subviews) {
//        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]])     {
//            dataNetworkItemView = subview;
//            break;
//        }
//    }
//    NetworkType nettype = Network_None;
//    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
//    nettype = [num intValue];
//    return nettype;
//}

//////////////////////////////message//////////////////////////////////////////////

- (void)showHUDmessage:(NSString *) message {
    
    [self showHUDmessage:message withImage:nil afterDelay:0];
}

- (void) showHUDmessage: (NSString *) message withImage:(NSString *)imagePath {
    
    [self showHUDmessage:message withImage:imagePath afterDelay:0];
}

- (void) showHUDmessage: (NSString *) message afterDelay:(NSTimeInterval) delay {
    
    [self showHUDmessage:message withImage:nil afterDelay:delay];
}

- (void) showHUDmessage:(NSString *)message withImage:(NSString *)imagePath afterDelay:(NSTimeInterval) delay {
    
    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progressHUD];
    
    if (imagePath != nil) {
        
        progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagePath]];
    }
    else {
        
        progressHUD.customView = [[UIImageView alloc] init];
    }
    progressHUD.delegate = self;
    progressHUD.animationType = MBProgressHUDAnimationZoom;
    progressHUD.mode = MBProgressHUDModeCustomView;
    progressHUD.label.text = message;
    progressHUD.label.font = [UIFont systemFontOfSize:10];
    [progressHUD showAnimated:YES];
    if (delay == 0) {
        
        [progressHUD hideAnimated:YES afterDelay:1.40];
    }
    else {
        
        [progressHUD hideAnimated:YES afterDelay:delay];
    }
}

//网络请求开始使用的等待消息
- (void) startHUDmessage:(NSString *) message {
    
    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progressHUD];
    progressHUD.animationType = MBProgressHUDAnimationZoom;
    progressHUD.delegate = self;
    progressHUD.label.text = message;
    [progressHUD showAnimated:YES];
}

- (void) stopHUDmessage {
    
    [progressHUD hideAnimated:YES];
}

- (void) stopHUDmessageByAfterDelay:(NSTimeInterval) delay {
    
    [progressHUD hideAnimated:YES afterDelay:delay];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    [progressHUD removeFromSuperview];
    progressHUD = nil;
}

//解决输入框被遮挡的问题

//- (void) animateTextField: (UITextField*) textField up: (BOOL) up
//
//{
//    
//    const int movementDistance = 50; // tweak as needed
//    
//    const float movementDuration = 0.3f; // tweak as needed
//    
//    int movement = (up ? -movementDistance : movementDistance);
//    
//    [UIView beginAnimations: @"anim" context: nil];
//    
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    
//    [UIView setAnimationDuration: movementDuration];
//    
//    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//    
//    [UIView commitAnimations];
//    
//}
//- (void) animateTextView: (UITextView*) textField up: (BOOL) up
//
//{
//    
//    const int movementDistance = 120+30; // tweak as needed
//    
//    const float movementDuration = 0.3f; // tweak as needed
//    
//    
//    int movement = (up ? -movementDistance : movementDistance);
//    
//    
//    [UIView beginAnimations: @"anim" context: nil];
//    
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    
//    [UIView setAnimationDuration: movementDuration];
//    
//    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//    
//    [UIView commitAnimations];
//    
//}

- (NSString *) md5:(NSString *)string {
    
    if (string == nil) {
        return nil;
    }
    const char *cstr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cstr, strlen(cstr), result);
    
    return [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]];
}

- (void) alertMessage:(NSString *)str{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示消息" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [_delegate doclick];
    }];
    
    [alert addAction:cancel];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) alert:(NSString *)str{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示消息" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)isEmpty:(NSString *)str{
    if (str == nil) {
        
        return YES;
    }
    
    if ([str isKindOfClass:[NSString class]] || ([str isKindOfClass:[NSNumber class]])) {
        
        NSString *temp = [NSString stringWithFormat:@"%@",str];
        
        if ([temp length] == 0 || [[temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
            
            return YES;
        }
    }
    return NO;

}


- (void)uploadHeadImage{
    __block typeof (self) weak_self = self;
    
    _picker = [[UIImagePickerController alloc] init];
    _picker.allowsEditing = YES;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择图片"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
        weak_self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [weak_self presentViewController:weak_self.picker animated:YES completion:nil];
        NSLog(@"从相册选择");
    }];
    UIAlertAction* fromCameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault                                                             handler:^(UIAlertAction * action) {
        NSLog(@"相机");
         weak_self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if(! [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            NSString *tips = @"相机不可用";
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:tips preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"取消");
            }];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"确定");
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_picker animated:YES completion:nil];
        if (![self getCameraRecordPermisson]) {
            NSString *tips = @"请在iPhone的“设置-隐私-相机”中允许访问相机";
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:tips preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"取消");
            }];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"确定");
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:fromCameraAction];
    [alertController addAction:fromPhotoAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
    //获得设备是否有访问相机权限
-(BOOL)getCameraRecordPermisson
    {
        NSString * mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied)
        {
            return NO;
        }
        return YES;
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
