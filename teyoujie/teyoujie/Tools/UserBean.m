//
//  UserBean.h
//  calculation
//
//  Created by fangyp on 15-01-16.
//  Copyright (c) 2015年 fangyp. All rights reserved.
//

#import "UserBean.h"

NSString *const UserSignIn              = @"3BF8B04EE3516A9C52CA77FB0395BD69";
NSString *const UserAccount             = @"84D770806429933EDEBB85C9D02D1FA4";
NSString *const UserPassword            = @"ACDCF0B56C16970FE83C8E1E28464594";
NSString *const UserDictionary          = @"8AB0BC35BE4ED95E5337A0CAF0DD24A4";
NSString *const UserMessage             = @"F1C8B45D957FABA61779422AB9C49316";
NSString *const UserMac                 = @"F16F6876C8D7A6A43A630D6EB7346991";

NSString *const UserEmail               = @"4ABC03C9219F2AA5536E7F154BD943FD";
NSString *const UserNickName            = @"AB5748327F0C011C8F60492F404D8F7B";
NSString *const UserHeadUrl             = @"0DB702393DA6D4980D88D827ED530DB9";
NSString *const UserLatitude           = @"CA591744E8776B5FFF7362E79F74189B";
NSString *const UserLongitude          = @"45373EF86AB36AF8C99A1E86CDA95F01";
NSString *const UserCityName           = @"7612934BF6B9AA87DBBCF7F88949C3F2";


@implementation UserBean

//static UserLocation *userLocation;
//
////位置单例
//+ (UserLocation *) locationManager {
//
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        userLocation = [[UserLocation alloc] init];
//    });
//    return userLocation;
//}


//用户设置相关
static UserSetting *userSetting;

+ (UserSetting *) userSetting{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userSetting = [[UserSetting alloc] init];
    });
    return userSetting;
}

+ (void) setSignIn:(BOOL) isLogin {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isLogin forKey:UserSignIn];
	[userDefaults synchronize];
}

+ (BOOL) isSignIn{
    
     return [[NSUserDefaults standardUserDefaults] boolForKey:UserSignIn];
}

//账号
+ (void) setAccount :(NSString *) account{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:account forKey:UserAccount];
	[userDefaults synchronize];
}

+ (NSString *) getAccount{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserAccount] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:UserAccount];
}

//密码
+ (void) setPassword :(NSString *) password{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:password forKey:UserPassword];
	[userDefaults synchronize];
}

+ (NSString *) getPassword{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserPassword] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:UserPassword];
}


//用户消息
+ (void) setUserMessage:(NSString *) message{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:message forKey:UserMessage];
    [userDefaults synchronize];
    
}
+ (NSString *) getUserMessage{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserMessage] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:UserMessage];
}

//用户Mac
+ (void) setUserMac:(NSString *) mac{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:mac forKey:UserMac];
    [userDefaults synchronize];
    
}
+ (NSString *) getUserMac{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserMac] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:UserMac];
}

//用户信息
+ (void) setUserDictionary :(NSDictionary *) dictionary{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dictionary forKey:UserDictionary];
    [userDefaults synchronize];
}

+ (NSDictionary *) getUserDictionary{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:UserDictionary];
}
+ (void) setUserInfo :(NSDictionary *) dictionary{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dictionary forKey:@"userInfo"];
    [userDefaults synchronize];
}

+ (NSDictionary *) getUserInfo{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"userInfo"];
}


+ (void) setCityList :(NSArray *) array{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:array forKey:@"cityList"];
    [userDefaults synchronize];
}

+ (NSArray *) getCityList{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"cityList"];
}


+ (void) userLogout {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setBool:NO forKey:UserSignIn];
//    [userDefaults setObject:@"" forKey:UserPassword];
    [userDefaults setObject:nil forKey:UserDictionary];
    [userDefaults synchronize];
}
//纬度
+ (void) setLatitude:(NSString *) latitude{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:latitude forKey:UserLatitude];
    [userDefaults synchronize];
    
}
+ (NSString *) getLatitude{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserLatitude] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:UserLatitude];
}

//经度 获取位置
+ (void) setLongitude:(NSString *) longitude{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:longitude forKey:UserLongitude];
    [userDefaults synchronize];
    
}
+ (NSString *) getLongitude{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserLongitude] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:UserLongitude];
}

//城市名字
+ (void) setCityName:(NSString *) cityName{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:cityName forKey:UserCityName];
    [userDefaults synchronize];
}
+ (NSString *) getCityName{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserCityName] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:UserCityName];
}


+ (void) allUserBeanInfo {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSLog(@"UserIsLogin                 = %d",[userDefaults boolForKey:UserSignIn]);
    NSLog(@"Account                     = %@",[userDefaults objectForKey:UserAccount]);
    NSLog(@"Password                    = %@",[userDefaults objectForKey:UserPassword]);
    NSLog(@"UserGender                  = %@",[userDefaults objectForKey:UserMessage]);

    
    //NSLog(@"UserCityName                = %@",[[UserBean locationManager] getCityName]);
    //NSLog(@"UserLatitude                = %@",[[UserBean locationManager] getLatitude]);
    //NSLog(@"UserLongitude               = %@",[[UserBean locationManager] getLongitude]);
//    NSLog(@"UserAddress                 = %@",[[UserBean locationManager] getAddress]);
//    NSLog(@"User                        = %@",[UserBean getUserDictionary]);
    
}

@end

NSString *const GPSCityName            = @"C6C010EAA0EAB13233E0E6B3DCD54668";

NSString *const UserCityId             = @"C8686B8680D405F7CC87A3D1114B7E30";

NSString *const UserAddress            = @"03C339092FCBDE3F89771B49CC384606";


//@implementation UserLocation
//
////城市ID
//- (void) setCityId:(NSString *) cityId{
//
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:cityId forKey:UserCityId];
//    [userDefaults synchronize];
//    
//}
//- (NSString *) getCityId{
//
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    if ([userDefaults objectForKey:UserCityId] == nil) {
//        return @"";
//    }
//    return [userDefaults objectForKey:UserCityId];
//}
//
//
////长地址字符串
//- (void) setAddress:(NSString *) address{
//
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:address forKey:UserAddress];
//    [userDefaults synchronize];
//}
//- (NSString *) getAddress{
//
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    if ([userDefaults objectForKey:UserAddress] == nil) {
//        return @"";
//    }
//    return [userDefaults objectForKey:UserAddress];
//}
//@end


NSString *const ServerUrl       = @"DomainHttpUrlKey";
//用户设置
@implementation UserSetting : NSObject

//服务器地址
- (void) setServerUrl:(NSString *) url {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:url forKey:ServerUrl];
    [userDefaults synchronize];
}
- (NSString *) getServerUrl{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:ServerUrl] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:ServerUrl];
}

@end
