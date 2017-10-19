//
//  UserBean.h
//  calculation
//
//  Created by fangyp on 15-01-16.
//  Copyright (c) 2015年 fangyp. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
//@class UserLocation;
@class UserSetting;

@interface UserBean : NSObject

//用户地理位置相关
//+ (UserLocation *) locationManager;

//用户设置相关
+ (UserSetting *) userSetting;

//用户是否登陆
+ (void) setSignIn:(BOOL) isLogin;
+ (BOOL) isSignIn;

//账号
+ (void) setAccount :(NSString *) account;
+ (NSString *) getAccount;

//密码
+ (void) setPassword :(NSString *) password;
+ (NSString *) getPassword;

//用户消息
+ (void) setUserMessage:(NSString *) message;
+ (NSString *) getUserMessage;

//用户Mac
+ (void) setUserMac:(NSString *) mac;
+ (NSString *) getUserMac;

//用户信息(token)
+ (void) setUserDictionary :(NSDictionary *) dictionary;
+ (NSDictionary *) getUserDictionary;

//用户信息
+ (void) setUserInfo :(NSDictionary *) dictionary;
+ (NSDictionary *) getUserInfo;
+ (void) setCityList :(NSArray *) array;
+ (NSArray *) getCityList;

//城市名字
+ (void) setCityName:(NSString *) cityName;
+ (NSString *) getCityName;
//注销
+ (void) userLogout;
//打印所有消息
+ (void) allUserBeanInfo;
//纬度
+ (void) setLatitude:(NSString *) latitude;
+ (NSString *) getLatitude;

//经度
+ (void) setLongitude:(NSString *) longitude;
+ (NSString *) getLongitude;


@end

//用户地理位置持久类
//@interface UserLocation : NSObject
//
////城市ID
//- (void) setCityId:(NSString *) cityId;
//- (NSString *) getCityId;
//
//
////长地址字符串
//- (void) setAddress:(NSString *) address;
//- (NSString *) getAddress;
//
//@end

//用户设置
@interface UserSetting : NSObject

//服务器地址
- (void) setServerUrl:(NSString *) url;
- (NSString *) getServerUrl;
@end
