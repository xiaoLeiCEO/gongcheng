//
//  AddGoodsCarView.m
//  freeBill
//
//  Created by 张梦川 on 16/12/15.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "AddGoodsCarView.h"
#import "ZMCHttpTool.h"
#import "CommonUrl.h"
#import "UserBean.h"
#import "ViewUtil.h"

@implementation AddGoodsCarView{
    BOOL _isShouCang;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isShouCang:) name:@"isshoucang" object:nil];
}

//是否收藏
-(BOOL)isShouCang: (NSNotification *)notification{

        if ([notification.userInfo[@"is_shoucang"] isEqualToString:@""]) {
            //未收藏
            _collectImage.image = [UIImage imageNamed:@"collect_an"];
            _isShouCang = NO;
            return NO;
        }
        else {
            //已收藏
            _isShouCang = YES;
            _collectImage.image = [UIImage imageNamed:@"collect"];
            return YES;
        }
    
}



//收藏的点击事件
- (IBAction)collectClick:(UIButton *)sender {
    
    if (_isShouCang){
            //删除收藏
                _collectImage.image = [UIImage imageNamed:@"collect_an"];
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                parameters[@"act"] = @"shanchu";
                parameters[@"token"] = [UserBean getUserDictionary][@"token"];
                parameters[@"goods_id"] = _goodsId;
                [ZMCHttpTool postWithUrl:FBCollectUrl parameters:parameters success:^(id responseObject) {
                    NSDictionary *dict = responseObject;
                    if ([dict[@"status"]  isEqualToString:@"4"]) {
                        //删除收藏成功
                        _isShouCang = !_isShouCang;
                        NSLog(@"%@",dict[@"msg"]);
                        [_delegate showAlert:dict[@"msg"]];
                    }else {
                        NSLog(@"%@",dict[@"msg"]);
                        [_delegate showAlert:dict[@"msg"]];
        
                    }
                } failure:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
    
    }else {
        
            if ([UserBean isSignIn]) {
                _collectImage.image = [UIImage imageNamed:@"collect"];
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                parameters[@"act"] = @"tianjia";
                parameters[@"token"] = [UserBean getUserDictionary][@"token"];
                parameters[@"goods_id"] = _goodsId;
                [ZMCHttpTool postWithUrl:FBCollectUrl parameters:parameters success:^(id responseObject) {
                    NSDictionary *dict = responseObject;
                    if ([dict[@"status"]  isEqualToString:@"1"]) {
                        //收藏成功
                        _isShouCang = !_isShouCang;
                        NSLog(@"%@",dict[@"msg"]);
                        [_delegate showAlert:dict[@"msg"]];
                    }else {
                        NSLog(@"%@",dict[@"msg"]);
                        [_delegate showAlert:dict[@"msg"]];
        
                    }
                } failure:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
            }
            else {
                //去登录
                [_delegate showLoginViewController];
            }
        
    }

    
    


}


@end



