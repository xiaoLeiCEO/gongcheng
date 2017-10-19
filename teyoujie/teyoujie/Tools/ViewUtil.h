

#import <UIKit/UIKit.h>

// 开发环境
#define HOST_URL @"http://192.168.1.254:8080"

// 测试环境
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
// 2.获得RGB颜色
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)
// 正式环境



typedef void (^image_loaded_block_t)(UIImage *image);


@interface ViewUtil : NSObject

// 16进制颜色
+ (UIColor *)hexColor:(NSString*)hexColor;

// 构建图片URL
+ (NSString *)buildImageUrl:(NSString *)imagePrefix suffix:(NSString *)imageSuffix size:(CGSize)size;

// 构建图片URL
+ (NSString *)buildImageUrl:(NSString *)imagePath;




// 异步加载图片,无缓存
+ (void)loadImageWithNoCache:(NSString *)imageUrl onFinished:(image_loaded_block_t)fb;

// 格式化数字到指定的长度，不足前面补0
+ (NSString *)formatNum:(NSInteger)num length:(NSInteger)len;


// 添加删除线
+ (void)strikeLineForLabel:(UILabel *)label;

// 去掉两边空格
+ (NSString *)trim:(NSString *)text;

// 是否有字符
+ (BOOL)hasText:(NSString *)text;

// 提示, 2秒之后消失
+ (void)broastAt:(UIView *)view text:(NSString *)text;

// hmac加密
+ (NSString *) hmacSha1:(NSString*)key text:(NSString*)text;

//邮箱
+(BOOL)isValidateEmail:(NSString *)email;

//手机号码验证
+ (BOOL)valiMobile:(NSString *)mobile;
    
// 字典排序并签名
+(NSString *)getSign:(NSDictionary *)dictionary;
// 时间戳转化
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString;
@end
