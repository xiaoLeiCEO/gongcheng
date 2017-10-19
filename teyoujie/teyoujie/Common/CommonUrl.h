//
//  CommonUrl.h
//  calculation
//
//  Created by fangyp on 15-01-17.
//  Copyright 2015年 fangyp. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAbs(__MAINURL__, __CHILDURL__) [NSString stringWithFormat:@"%@%@", __MAINURL__, __CHILDURL__]

//正式域名：http://momohudong.com
//测试域名：http://cs.momohudong.com
#define DOMAINURL @"http://www.teyoujie.com"
#define IMGURL @"http://www.teyoujie.com/"
#define IMGFORJAVAURL @"http://oms.teyoujie.com"
#define signStr @"b6r9x3u8a6q5klv7"



//用户登录
#define FBLoginUrl kAbs(DOMAINURL,@"/api/hd/user/login.php")
//用户注册
#define FBRegUrl kAbs(DOMAINURL,@"/api/hd/user/register.php")
//获取手机验证码
#define FBSmsCode kAbs(DOMAINURL,@"/api/hd/user/send_msg.php")
//获取用户信息
#define FBGetUserInfo kAbs(DOMAINURL,@"/api/hd/user/user.php")
// 上传头像
#define FBUploadImgUrl kAbs(DOMAINURL,@"/api/hd/user/upload.php")
// 商品分类
#define FBCategoryUrl kAbs(IMGFORJAVAURL,@"/hd/Android/shopCategory")

// 获取分类直营商品列表
#define FBShopShangPinUrl kAbs(DOMAINURL,@"/api/shop/get_cc_goods_list.php")
// 退出登录
#define FBLogoutUrl kAbs(DOMAINURL,@"/api/hd/user/logout.php")
// 忘记密码
#define FBForgetUrl kAbs(DOMAINURL,@"/api/hd/user/user.php")

// 修改密码
#define FBResetUrl kAbs(DOMAINURL,@"/api/hd/user/user.php")
// 编辑个人信息
#define FBEditUserInfoUrl kAbs(DOMAINURL,@"/api/hd/user/user.php")

// 省市三级联动
#define FBAddressUrl kAbs(DOMAINURL,@"/api/shop/get_region.php")

// 定位地址
#define FBlocationUrl @"http://api.map.baidu.com/geocoder?location="

// 实名认证
#define FBNameCardUrl kAbs(DOMAINURL,@"/api/hd/user/cards.php")

//设置默认收货地址
#define FBSetDefaultAddressUrl kAbs(DOMAINURL,@"/api/shop/get_address.php")
// 增加、删除、编辑、查询收获地址
#define FBAddressReceiveUrl kAbs(DOMAINURL,@"/api/shop/address.php")
//获取默认收货地址
#define FBGetAdressUrl kAbs(DOMAINURL,@"/api/shop/get_default_address.php")

// 商品详情
#define FBShopDetailUrl kAbs(DOMAINURL,@"/api/shop/get_cc_goods.php")
// 评论列表
#define FBCommentListUrl kAbs(DOMAINURL,@"/api/shop/cc_comment.php")


//首页商品列表
#define FBHomeGoodsListUrl kAbs(DOMAINURL,@"/api/shop/goods_list_index.php")
// 首页热点列表
#define FBHomeHotListUrl kAbs(IMGFORJAVAURL,@"/hd/Android/fuWuShangpin")
//首页获取服务商家店铺详情
#define FBHomeServiceStore kAbs(DOMAINURL,@"/api/shop/fuwu_get_shop_index.php")

//首页猜你喜欢
#define FBGuessLikeUrl kAbs (DOMAINURL,@"/api/shop/fuwu_goods_for_index.php")
// 服务详情
#define FBFuWuDetailUrl kAbs(IMGFORJAVAURL,@"/hd/Android/fuWuGoods")

// 评论列表
#define FBFUWUCommentListUrl kAbs(IMGFORJAVAURL,@"/hd/Android/fuWuPingLun")

// 评论列表商品
#define FBShopCommentListUrl kAbs(IMGFORJAVAURL,@"/hd/Android/ccPingLun")

//添加、删除、清空、我的购物车
#define FBCart kAbs(DOMAINURL,@"/api/shop/cc_cart.php")


//支付宝支付
#define FBAlipayUrl kAbs(DOMAINURL,@"/api/shop/pay_cc_goods_alipay_app.php")


//微信支付直营后台返回appId，partnerId，prepayId，nonceStr，timeStamp，package的参数
#define FBOrderZhiYingUrl kAbs(DOMAINURL,@"/api/shop/pay_cc_goods_wx_app.php")
//微信支付服务后台返回appId，partnerId，prepayId，nonceStr，timeStamp，package的参数
#define FBOrderFuWuUrl kAbs(DOMAINURL,@"/api/shop/pay_fuwu_goods_wx_app.php")
//服务类生成订单号
#define FBOrderNumUrl kAbs(DOMAINURL,@"/api/hd/fuwu_order.php")
//支付成功页面获取票券
#define FBGetTicket kAbs(DOMAINURL,@"/api/shop/get_fuwu_vou.php")
//订单列表
#define FBGetOrderUrl kAbs(DOMAINURL,@"/api/shop/get_cc_order_list.php")
//未付款订单支付接口
#define FBOrderPayUrl kAbs(DOMAINURL,@"/api/shop/pay_order.php")
//删除订单
#define FBDelOrderUrl kAbs(DOMAINURL,@"/api/shop/del_order.php")

// 附近商品列表
#define FBFUWUNearListUrl kAbs(DOMAINURL,@"/api/shop/get_near_shop.php")
// 附近八个分类的按钮
#define FBEightCatUrl kAbs(IMGFORJAVAURL,@"/hd/Android/fuWuCategory")

// 模糊搜索
#define FBFuWuSearchUrl kAbs(DOMAINURL,@"/api/shop/fuwu_search_log.php")
#define FBZhiYingSearchUrl kAbs(DOMAINURL,@"/api/shop/cc_search_log.php")
// 积分商城
#define FBjifenMailListUrl kAbs(DOMAINURL,@"/api/shop/exchange_goods.php")
//积分兑换商品接口
#define FBjiFenDuiHuanGoodsUrl kAbs(DOMAINURL,@"/api/shop/pay_exchange_goods.php")
//积分兑换记录接口
#define FBjiFenDuiHuanJiLu kAbs(DOMAINURL,@"/api/shop/exchange_goods_log.php")
//积分提现
#define FBjifenTiXianUrl kAbs(DOMAINURL,@"/api/shop/jifen_tixian.php")
//积分领取
#define FBjifenLingQuUrl kAbs(DOMAINURL,@"/api/shop/jifen_lingqu.php")
//服务店商品券列表
#define FBFuVoucherListUrl kAbs(DOMAINURL,@"/api/hd/fuwu_voucher_list.php")

//收藏
#define FBCollectUrl kAbs(DOMAINURL,@"/api/shop/get_goods_shoucang.php")


