

#import "ViewUtil.h"
#import "UIImageView+WebCache.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "CommonUrl.h"
@implementation ViewUtil

// 16进制颜色
+ (UIColor *)hexColor:(NSString*)hexColor {
    hexColor = [hexColor substringFromIndex:1];
    
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
}

// 构建图片URL
+ (NSString *)buildImageUrl:(NSString *)imagePrefix suffix:(NSString *)imageSuffix size:(CGSize)size {
    NSString *imageRet = @"";
    if (size.width > 0 && size.height > 0) {
        imageRet = [NSString stringWithFormat:@"-res-%d-%d", (int)size.width * 3, (int)size.height * 3];
    } else if (size.width > 0) {
        imageRet = [NSString stringWithFormat:@"-res-%d", (int)size.width * 2];
    }
    
    return [NSString stringWithFormat:@"%@%@/%@%@", HOST_URL,
            imagePrefix, imageRet, imageSuffix];
}

// 构建图片URL
+ (NSString *)buildImageUrl:(NSString *)imagePath {
    NSString *appName =@"cloudsmall-call";
    NSString *imageUrl = [NSString stringWithFormat:@"%@/%@/%@", HOST_URL,appName, imagePath];
    
    return imageUrl;
}


+(UIImage *)compressImageWith:(UIImage *)image {
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = 640;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

// 异步加载图片,无缓存
+ (void)loadImageWithNoCache:(NSString *)imageUrl onFinished:(image_loaded_block_t)fb {
    dispatch_queue_t asyncQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(asyncQueue, ^{
        UIImage *image = nil;
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        if (imageData) {
            image = [UIImage imageWithData:imageData];
        }
        
        if (!image) {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loading_xiaocaiwa" ofType:@"png"]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            fb(image);
        });
    });
}


// 格式化数字到指定的长度，不足前面补0
+ (NSString *)formatNum:(NSInteger)num length:(NSInteger)len {
    NSMutableString *fmt = [NSMutableString stringWithCapacity:10];
    [fmt appendString:@"%0"];
    [fmt appendString:[NSString stringWithFormat:@"%ld", (long)len]];
    [fmt appendString:@"ld"];
    
    NSString *numStr = [NSString stringWithFormat:fmt, num];
        
    return numStr;
}



// 添加删除线
+ (void)strikeLineForLabel:(UILabel *)label {
    NSString *text = label.text;
    NSUInteger length = [text length];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];
    [attr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attr addAttribute:NSStrikethroughColorAttributeName value:[ViewUtil hexColor:@"#999999"] range:NSMakeRange(0, length)];
    
    label.text = nil;
    [label setAttributedText:attr];
}

// 去掉两边空格
+ (NSString *)trim:(NSString *)text {
    return [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// 是否有字符
+ (BOOL)hasText:(NSString *)text {
    NSString *cleanText = [self trim:text];
    if (!cleanText || [cleanText length] <= 0) {
        return NO;
    }
    return YES;
}

// 提示, 2秒之后消失
+ (void)broastAt:(UIView *)view text:(NSString *)text {
    UIView *broastView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    broastView.layer.cornerRadius = 5;
    broastView.backgroundColor = [UIColor grayColor];
    
    UILabel *broastLabel = [[UILabel alloc] initWithFrame:broastView.bounds];
    broastLabel.numberOfLines = 0;
    
    CGSize maximumSize = CGSizeMake(180,9999);
//    CGSize factSize =[text sizeWithFont:[UIFont systemFontOfSize:14]
//                      constrainedToSize:maximumSize
//                          lineBreakMode:broastLabel.lineBreakMode];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize factSize = [text boundingRectWithSize:maximumSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    broastLabel.text = text;
    broastLabel.textAlignment = NSTextAlignmentCenter;
    broastLabel.textColor = [UIColor whiteColor];
    broastLabel.font = [UIFont systemFontOfSize:14];
    
    CGRect viewFrame = broastLabel.frame;
    viewFrame.size.width = 180;
    viewFrame.size.height = factSize.height;
    
    broastLabel.frame = viewFrame;
    
    CGRect broastFrame = broastView.frame;
    broastFrame.size.height = broastLabel.frame.size.height + 20;
    
    broastView.frame = broastFrame;
    
    [self addSubViewVerticalIn:broastView subView:broastLabel originX:10];
    
    [view addSubview:broastView];
    
    broastView.center = view.center;
    broastFrame = broastView.frame;
    broastFrame.origin.y = broastFrame.origin.y - 20;
    broastView.frame = broastFrame;
    
    [UIView animateWithDuration:5.0f animations:^{
        broastView.alpha = 0;
    } completion:^(BOOL finished) {
        [broastView removeFromSuperview];
    }];
}


+ (void)addSubViewVerticalIn:(UIView *)parentView subView:(UIView *)subView originX:(CGFloat)originX {
    CGRect subRect = subView.frame;
    subRect.origin.x = originX;
    subRect.origin.y = (parentView.frame.size.height - subView.frame.size.height) / 2;
    
    subView.frame = subRect;
    
    [parentView addSubview:subView];
}

+ (NSString *) hmacSha1:(NSString*)key text:(NSString*)text
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
        hash = output;
        return hash;
    
}

////邮箱
//+ (BOOL) validateEmail:(NSString *)email
//{
//    NSString *emailRegex = @"^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//   
//    return [emailTest evaluateWithObject:email];
//}
//
//
////手机号码验证
//+ (BOOL) validateMobile:(NSString *)mobile
//{
//    //手机号以13， 15，18,17开头，八个 \d 数字字符
//    NSString *phoneRegex = @"^1+[3578]+\\d{9}";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    return [phoneTest evaluateWithObject:mobile];
//}


//电话格式检查
+ (BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

//邮箱格式检查
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


+ (NSString *)MD5:(NSString *)mdStr
{
    const char *original_str = [mdStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    NSLog(@"%@",[hash lowercaseString]);
    return [hash lowercaseString];
}

+(NSString *)getSign:(NSDictionary *)dictionary{
    NSArray* arr = [dictionary allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    NSString *sign = @"";
    for (int i = 0; i< arr.count; i++) {
        sign = [NSString stringWithFormat:@"%@%@",sign,arr[i]];
    }
    NSString *signSalting = [NSString stringWithFormat:@"%@%@",sign,signStr];
    return [self MD5:signSalting];
}


+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
@end
