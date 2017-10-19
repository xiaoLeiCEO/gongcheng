//
//  UILabel+StringFrame.h
//  kitchen
//
//  Created by 张梦川 on 15/10/13.
//  Copyright © 2015年 fangyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface UILabel (StringFrame)
-(CGSize)boundingRectWithString:(NSString *)str withSize:(CGSize)size;
-(CGSize)boundingRectWithString:(NSString *)str withSize:(CGSize)size withFont:(int)font;
@end
