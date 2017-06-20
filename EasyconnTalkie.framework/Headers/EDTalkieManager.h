//
//  EDTalkieManager.h
//  EasyconnTalkie
//
//  Created by ch on 2017/6/5.
//  Copyright © 2017年 carbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EDEnumerate.h"
#import "EDRoomInfo.h"
#import "EDUserInfo.h"


@class EDTalkieManager;

@protocol EDTalkieManagerSelfDelegate <NSObject>

@optional

//停止说话时回调
- (void)onSelfStopSpeak:(StopSpeakType)stopSpeakType;

//自己的角色被改变时回调
- (void)onSelfRoleChange:(RoomRole)roomRole;

//自己被踢出当前房间时回调
- (void)onSelfKickOut;

//自己被禁言时回调
- (void)onSelfSilenced:(NSInteger)hour;

//自己恢复禁言时回调
- (void)onSelfUnSilence;

//对讲服务连接成功后回调 表示可以正常收听语音消息
- (void)onTalkieServerConnectedOnlineSize:(NSInteger)onlineSize totalSize:(NSInteger)totalSize;

//对讲服务断开后回调 表示自己已离线（无法收听语音消息）如果是offline或logout或登录冲突则不会自动连接 需手动执行online操作才能再次连接
- (void)onTalkieServerDisconnected;
@end

@class EDTalkieManager;

@protocol EDTalkieManagerMemberDelegate <NSObject>

@optional
//其它用户开始发言事件
- (void)onMemberStartSpeak:(NSString*)openId;

//其它用户结束发言事件
- (void)onMemberStopSpeak:(NSString*)openId;

//其它用户位置变更事件
- (void)onMemberLocationChangeOpenId:(NSString*)openId latitude:(CGFloat)lat longitude:(CGFloat)lon speed:(CGFloat)speed direction:(CGFloat)direction;
//其他用户角色改变时
- (void)onMemberRoleChangeOpenId:(NSString*)openId roomRole:(RoomRole)roomRole;

//其他用户上线时
- (void)onMemberOnlineOpenId:(NSString*)openId onlineSize:(NSInteger)onlineSize totalSize:(NSInteger)totalSize;

//其他用户下线时
- (void)onMemberOfflineOpenId:(NSString*)openId onlineSize:(NSInteger)onlineSize totalSize:(NSInteger)totalSize;

//其他用户退出房间时
- (void)onMemberLeaveOpenId:(NSString*)openId onlineSize:(NSInteger)onlineSize totalSize:(NSInteger)totalSize;

//其他用户更改房间名称时
- (void)onMemberChangerRoomNameOpenId:(NSString*)openId roomName:(NSString*)roomName;

//其他用户打开位置共享
- (void)onMemberOpenLocationSharingChange:(NSString*)openId;

//其他用户关闭位置共享
- (void)onMemberCloseLocationSharingChange:(NSString*)openId;
@end

@interface EDTalkieManager : NSObject

@property (nonatomic, weak) id<EDTalkieManagerSelfDelegate> selfDelegate;
@property (nonatomic, weak) id<EDTalkieManagerMemberDelegate> memberDelegate;

/**
 *  初始化
 */
+ (instancetype)shareInstance;

+ (void)setLog:(BOOL)log;

#pragma mark Http

#pragma mark 帐户相关操作

/**
 *  初始化
 *  @param appId   应用唯一标识,分配的appID
 */
+ (void)initWithAppId:(NSString*)appId;

/**
 *  摧毁服务
 */
+ (void)destroy;

/**
 *  登陆服务器，获取openID
 *
 *  @param secret  secretId
 *  @param userID  用户ID，由调用者产生或分配
 *  @param callback  连接结果回调
 */
- (void)loginWithSecret:(NSString*)secret userID:(NSString *)userID callback:(void(^)(NSError *error,NSString *token,NSString *openID))callback;

/**
 *  授权
 *  @param token 字符串
 *  @param openId 字符串
 */
- (void)oauthWithToken:(NSString*)token openId:(NSString*)openId callback:(void(^)(NSError *error))callback;

#pragma mark 房间操作

/**
 * 获取全局静音设置
 *
 * @param callback 全局静音
 */
- (void)getGlobalSetting:(void(^)(NSError *error,BOOL gMute))callback;

/**
 *  创建频道
 *
 *  @param roomName 房间名 #可选
 *  @param callback   创建房间回调
 */
- (void)createRoom:(NSString*)roomName callback:(void(^)(NSError *error,EDRoomInfo *roomInfo))callback;

/**
 *  退出频道
 *
 *  @param roomId  房间Id
 *  @param callback  退出房间回调,error:错误信息，为nil时表示成功
 */
- (void)leaveRoom:(NSString*)roomId callback:(void(^)(NSError *error))callback;

/**
 *  设置频道列表轮询事件
 *
 *  @param timeInterval  轮询间隔，单位秒，但不能小于服务器配置(5秒)
 *  @param callback  设置频道列表轮询事件回调,roomInfoList:结果信息，为nil时表示成功
 */
- (void)setRoomListPollingListener:(NSTimeInterval)timeInterval callback:(void(^)(NSError *error,NSArray <EDRoomInfo>*roomInfoList))callback;

/**
 *  停止频道列表轮询
 */
- (void)stopRoomListPolling;

/**
 *  进入频道 只有进入频道后才能请求发言、更新位置、收到其它用户的发言和位置
 *  @param roomId  房间号
 *  @param callback 上线结果回调,error:错误信息，为nil时表示成功
 */
- (void)online:(NSString *)roomId callback:(void(^)(NSError *error))callback;

/**
 *  离开频道 离开频道后不能请求发言、更新位置、收到其它用户的发言和位置
 */
- (void)offline;

/**
 *  获得频道信息和设置
 *  @param roomId  房间号
 *  @param callback 结果回调,roomInfo:返回结果
 */
- (void)getRoomInfo:(NSString*)roomId callback:(void(^)(EDRoomInfo *roomInfo ,NSError *error))callback;

/**
 *  获得频道成员列表
 *  @param roomId  房间号
 *  @param callback 结果回调,userInfoList:返回结果
 */
- (void)getUserList:(NSString*)roomId page:(unsigned int)page size:(unsigned int)size callback:(void(^)(NSArray <EDUserInfo>*userInfoList,NSError *error))callback;

/**
 *  获得成员信息和设置
 *  @param roomId  房间号
 *  @param callback 结果回调,userInfo:返回结果
 */
- (void)getUserInfo:(NSString*)roomId openId:(NSString*)openId callback:(void(^)(EDUserInfo *userInfo,NSError *error))callback;

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
 *  设置对讲播放的音量
 *  @param volume 音量值，取值范围[0,1]，设置其他值时无效
 */
- (void)setTalkieVolume:(CGFloat)volume;

/**
 *  修改房间名称
 */
- (void)setRoomName:(NSString*)roomName roomId:(NSString*)roomId callback:(void(^)(NSError *error))callback;

/**
 *  静音开关
 */
- (void)setGlobalMute:(BOOL)isMute callback:(void(^)(NSError *error))callback;

/**
 *  位置共享开关
 */
- (void)setLocationSharing:(BOOL)isSharing roomId:(NSString*)roomId callback:(void(^)(NSError *error))callback;

/**
 *  设置房间管理角色
 */
- (void)setRoomRoleWithRoomId:(NSString*)roomId openId:(NSString*)openId role:(RoomRole)userRole callback:(void(^)(NSError *error))callback;

/**
 *  移除用户(踢人)
 *  只能高layer的对低layer的操作,相同layer用户不可操作
 *  kickUser的sideEffect:被踢的用户1天之内不能再次加入此房间
 *
 *  @param roomId  房间Id
 *  @param userIdArray  要踢除的用户Id
 *  @param action  必选 add 踢人， remove 取消踢人
 *  @param hour    一定时间内被移除用
 *  @param callback  移除用户(踢人)回调
 */
- (void)kickUserWithRoomId:(NSString*)roomId userIdArray:(NSArray*)userIdArray action:(NSString*)action hour:(NSInteger)hour callback:(void(^)(NSError *error))callback;

/**
 *  禁言用户
 *
 *  @param roomId  房间Id
 *  @param userIdArray  要踢除的用户Id
 *  @param action  必选 add禁言， remove 取消禁言
 *  @param hour    单位小时
 *  @param callback  禁言用户回调
 */
- (void)silencedUserWithRoomId:(NSString*)roomId userIdArray:(NSArray*)userIdArray action:(NSString*)action hour:(NSInteger)hour callback:(void(^)(NSError *error))callback;

/**
 *  获得发言状态
 */
- (MicrophoneState)getSpeakState;

@end
