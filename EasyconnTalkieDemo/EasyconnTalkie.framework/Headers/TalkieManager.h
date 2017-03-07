//
//  TalkieManager.h
//  TalkieSDK
//
//  Created by wzt on 2017/1/19.
//  Copyright © 2017年 wzt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//对讲连接状态
typedef enum{
    ConnectStateConnected = 0,      //连接成功
    ConnectStateDisconnect = 1,     //连接断开
} ConnectState;


@interface TalkieManager : NSObject

/**
 *  初始化
 */
+ (instancetype)shareInstance;


/**
 *  登陆服务器，获取openID
 *
 *  @param appID  分配的appID
 *  @param userID  用户ID，由调用者产生或分配
 *  @param callback  连接结果回调,error:错误信息，为nil时表示成功;openID:对讲账户体系对应的用户ID
 */
- (void)loginWithAppID:(NSString *)appID userID:(NSString *)userID callback:(void(^)(NSError *error,NSString *openID))callback;

/**
 *  对讲上线，上线之后可进行对讲和收听对讲
 *  @param roomID  房间号
 *  @param callback 上线结果回调,error:错误信息，为nil时表示成功
 */
- (void)online:(NSString *)roomID callback:(void(^)(NSError *error))callback;

/**
 *  对讲下线
 */
- (void)offline;

/**
 *  请求发言
 *  @param callback 请求结果回调,error:错误信息，为nil时表示成功
 */
- (void)requestSpeakWithResult:(void(^)(NSError *error))callback;

/**
 *  结束发言
 */
- (void)stopSpeak;

/**
 *  上传位置信息
 *  @param lat 纬度
 *  @param lon 经度
 *  @param speed 速度
 *  @param direction 方向
 */
- (void)uploadLocationWithLat:(CGFloat)lat lon:(CGFloat)lon speed:(CGFloat)speed direction:(CGFloat)direction;

/**
 *  监听其他用户位置更新
 *  @param callback 监听回调
 */
- (void)listeningOtherUserLocationChanged:(void(^)(NSString *openID,CGFloat lat,CGFloat lon,CGFloat speed,CGFloat direction))callback;

/**
 *  监听其他用户开始发言
 *  @param callback 监听回调
 */
- (void)listeningOtherUserStartSpeak:(void(^)(NSString *openID))callback;


/**
 *  监听其他用户停止发言
 *  @param callback 监听回调
 */
- (void)listeningOtherUserStopSpeak:(void(^)(NSString *openID))callback;


/**
 *  监听连接状态
 *  @param callback 监听回调
 */
- (void)listeningConnectState:(void(^)(ConnectState state))callback;

@end
