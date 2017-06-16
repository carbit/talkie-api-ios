//
//  EDEnumerate.h
//  EasyconnTalkie
//
//  Created by ch on 2017/6/5.
//  Copyright © 2017年 carbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EDEnumerate : NSObject

//对讲连接状态
typedef enum{
    ConnectStateConnected = 0,      //连接成功
    ConnectStateDisconnect = 1,     //连接断开
} ConnectState;

//获取结构的类型
typedef enum {
    RoomInfoStructType_base = 0,
    RoomInfoStructType_simple,
    RoomInfoStructType_complete
}RoomInfoStructType;

//发言状态
typedef enum{
    MicrophoneState_ERROR = 0,//错误(检查是否配置了ImService)
    IntercomState_LEISURE,//空闲
    IntercomState_REQUEST_SPEAKING,//正在请求发言中
    IntercomState_SELF_SPEAKING,//自己正在发言
    IntercomState_MEMBER_SPEAKING //其他人员正在发言
} MicrophoneState;

//房间角色
typedef enum {
    RoomRole_OWNER = 0,          //群主
    RoomRole_ADMINISTRATOR = 11, //管理员
    RoomRole_GENERAL_MEMBER = 51 //普通成员
}RoomRole;

//停止说话类型
typedef enum {
    StopSpeakType_BY_HAND = 0,                 //手动丢麦
    StopSpeakType_BY_HIGHER_PERMISSION,        //更高的请求发言的权限打断
    StopSpeakType_BY_SERVER_NO_RECEIVER_AUDIO, //服务端一段时间未收到语音包 强制打断
    StopSpeakType_BY_SPEAK_TIME_OUT,           //发言时长达到最大值 服务端强制打断
    StopSpeakType_BY_AUTO,                     //抢麦3秒无发言自动丢麦(群主除外)
    StopSpeakType_BY_SOCKET_SERVER_DISCONNECT  //网络不稳定时 Socket服务断开时 强制打断
}StopSpeakType;

typedef NS_ENUM(NSInteger, EDIntercomRoomPrivilege) {
    // 1 开头权限用于普通用户在房间内的操作权限定义
    AllowSpeakPrivilege                 =   1001,   // 允许发言
    AllowChangeRoomNamePrivilege        =   1002,   // 允许修改房间名称
    AllowChangeDestinationPrivilege     =   1003,   // 允许修改房间目的地
    AllowInviteUserPrivilege            =   1004,   // 允许邀请好友
    
    // 2 开头权限用于管理员对单个用户的管理操作定义
    AllowKickUserPrivilege              =   2001,   // 允许将用户踢出房间
    AllowMuteUserPrivilege              =   2002,   // 允许将用户禁言
    AllowUnmuteUserPrivilege            =   2003,   // 允许恢复用户发言
    
    // 3 开头权限用于管理员对整个房间的管理操作定义
    AllowChangePeopleNumberPrivilege    =   3001,   // 允许修改房间人数上限
    AllowChangeSpeakTimePrivilege       =   3002,   // 允许修改房间发言时长
    AllowDisableSpeakPrivilege          =   3003,   // 允许禁止房间内所有普通用户发言
    AllowDeleteRoomPrivilege            =   3004    // 允许删除/解散房间
};

@end
