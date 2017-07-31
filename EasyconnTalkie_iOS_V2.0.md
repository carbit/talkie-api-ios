亿连对讲 SDK iOS 接入说明


---------------
目录

[一、SDK接入](#SDK接入)

[二、SDK接口方法说明](#SDK接口方法说明)

[三、SDK接口代理说明](#SDK接口代理说明)

[四、类说明](#类说明)

------------------

<h2 id="SDK接入">一、SDK接入</h2>

将EasyconnTalkie.framework添加到工程中

在pch文件中引入
```Objective-C
#import <EasyconnTalkie/EDTalkieManager.h>
```

是否打印Log
```Objective-C
/**
* @param log BOOL YES:打印SDK日志 NO:不打印SDK日志
*/
+ (void)setLog:(BOOL)log;
```

<h2 id="SDK接口方法说明">二、SDK接口方法说明</h2>

调用示例
[[EDTalkieManager shareInstance] 方法名];

1、 初始化
```Objective-C
/**
*  初始化
*  @param appId   应用唯一标识,分配的appID
*/
+ (void)initWithAppId:(NSString*)appId;
```
2、 摧毁服务
```Objective-C
+ (void)destroy;
```
3、 登陆服务器，获取openID
```Objective-C
/**
*  登陆服务器，获取openID
*
*  @param secret  secretId
*  @param userID  用户ID，由调用者产生或分配
*  @param callback  连接结果回调
*/
- (void)loginWithSecret:(NSString*)secret userID:(NSString *)userID callback:(void(^)(NSError *error,NSString *token,NSString *openID))callback;
```
4、 授权登陆
```Objective-C
/**
*  授权
*  @param token 字符串
*  @param openId 字符串
*/
- (void)oauthWithToken:(NSString*)token openId:(NSString*)openId callback:(void(^)(NSError *error))callback;
```
5、 获取全局静音设置
```Objective-C
/**
* 获取全局静音设置
*
* @param callback 全局静音
*/
- (void)getGlobalSetting:(void(^)(NSError *error,BOOL gMute))callback;
```
6、 创建频道
```Objective-C
/**
*  创建频道
*
*  @param roomName 房间名 #可选
*  @param callback   创建房间回调
*/
- (void)createRoom:(NSString*)roomName callback:(void(^)(NSError *error,EDRoomInfo *roomInfo))callback;
```
7、 退出频道
```Objective-C
/**
*  退出频道
*
*  @param roomId  房间Id
*  @param callback  退出房间回调,error:错误信息，为nil时表示成功
*/
- (void)leaveRoom:(NSString*)roomId callback:(void(^)(NSError *error))callback;
```
8、 设置频道列表轮询事件
```Objective-C
/**
*  设置频道列表轮询事件
*
*  @param timeInterval  轮询间隔，单位秒，但不能小于服务器配置(5秒)
*  @param callback  设置频道列表轮询事件回调,roomInfoList:结果信息，为nil时表示成功
*/
- (void)setRoomListPollingListener:(NSTimeInterval)timeInterval callback:(void(^)(NSError *error,NSArray <EDRoomInfo>*roomInfoList))callback;
```
9、 停止频道列表轮询
```Objective-C
/**
*  停止频道列表轮询
*/
- (void)stopRoomListPolling;
```
10、 进入频道
```Objective-C
/**
*  进入频道 只有进入频道后才能请求发言、更新位置、收到其它用户的发言和位置
*  @param roomId  房间号
*  @param callback 上线结果回调,error:错误信息，为nil时表示成功
*/
- (void)online:(NSString *)roomId callback:(void(^)(NSError *error))callback;
```
11、 离开频道
```Objective-C
/**
*  离开频道 离开频道后不能请求发言、更新位置、收到其它用户的发言和位置
*/
- (void)offline;
```
13、 获得频道信息和设置
```Objective-C
/**
*  获得频道信息和设置
*  @param roomId  房间号
*  @param callback 结果回调,roomInfo:返回结果
*/
- (void)getRoomInfo:(NSString*)roomId callback:(void(^)(EDRoomInfo *roomInfo ,NSError *error))callback;
```
14、 获得频道成员列表
```Objective-C
/**
*  获得频道成员列表
*  @param roomId  房间号
*  @param callback 结果回调,userInfoList:返回结果
*/
- (void)getUserList:(NSString*)roomId page:(unsigned int)page size:(unsigned int)size callback:(void(^)(NSArray <EDUserInfo>*userInfoList,NSError *error))callback;
```
15、 获得成员信息和设置
```Objective-C
/**
*  获得成员信息和设置
*  @param roomId  房间号
*  @param callback 结果回调,userInfo:返回结果
*/
- (void)getUserInfo:(NSString*)roomId openId:(NSString*)openId callback:(void(^)(EDUserInfo *userInfo,NSError *error))callback;
```
16、 请求发言
```Objective-C
/**
*  请求发言
*  @param callback 请求结果回调,error:错误信息，为nil时表示成功
*/
- (void)requestSpeakWithResult:(void(^)(NSError *error))callback;
```
17、 结束发言
```Objective-C
/**
*  结束发言
*/
- (void)stopSpeak;
```
18、 上传位置信息
```Objective-C
/**
*  上传位置信息
*  @param lat 纬度
*  @param lon 经度
*  @param speed 速度
*  @param direction 方向
*/
- (void)uploadLocationWithLat:(CGFloat)lat lon:(CGFloat)lon speed:(CGFloat)speed direction:(CGFloat)direction;
```
19、 设置对讲播放的音量
```Objective-C
/**
*  设置对讲播放的音量
*  @param volume 音量值，取值范围[0,1]，设置其他值时无效
*/
- (void)setTalkieVolume:(CGFloat)volume;
```
19、 修改房间名称
```Objective-C
/**
*  修改房间名称
*/
- (void)setRoomName:(NSString*)roomName roomId:(NSString*)roomId callback:(void(^)(NSError *error))callback;
```
20、 静音开关
```Objective-C
/**
*  静音开关
*/
- (void)setGlobalMute:(BOOL)isMute callback:(void(^)(NSError *error))callback;
```
21、 位置共享开关
```Objective-C
/**
*  位置共享开关
*/
- (void)setLocationSharing:(BOOL)isSharing roomId:(NSString*)roomId callback:(void(^)(NSError *error))callback;
```
22、 设置房间管理角色
```Objective-C
/**
*  设置房间管理角色
*/
- (void)setRoomRoleWithRoomId:(NSString*)roomId openId:(NSString*)openId role:(RoomRole)userRole callback:(void(^)(NSError *error))callback;
```
23、 移除用户(踢人)
```Objective-C
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
```
24、 禁言用户
```Objective-C
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
```
25、 获得发言状态
```Objective-C
/**
*  获得发言状态
*/
- (MicrophoneState)getSpeakState;
```
26、 退出登录
```Objective-C
/**
* APP登出
*
* @param callback APP登出
*/
- (void)oauthLogoutCallback:(void(^)(NSError *error))callback;
```
27、 房间列表
```Objective-C
/**
*  房间列表
*
*  @param callback  房间列表,error:错误信息，为nil时表示成功
*/
- (void)getRoomList:(void(^)(NSError *error,NSArray <EDRoomInfo>*roomInfoList))callback;
```

<h2 id="SDK接口代理说明">三、SDK接口代理说明</h2>

在要调用的类引进EDTalkieManagerSelfDelegate,EDTalkieManagerMemberDelegate

**Tips：selfDelegate针对用户自己的代理，memberDelegate处理房间成员的代理**

<h3>selfDelegate</h3>

停止说话时回调
```Objective-C
/**
*  停止说话时回调
*
*  @param stopSpeakType  停止的type
*/
- (void)onSelfStopSpeak:(StopSpeakType)stopSpeakType;
```
自己的角色被改变时回调
```Objective-C
/**
*  自己的角色被改变时回调
*
*  @param roomRole  角色
*/
- (void)onSelfRoleChange:(RoomRole)roomRole;
```
自己被踢出当前房间时回调
```Objective-C
/**
*  自己被踢出当前房间时回调
*
*/
- (void)onSelfKickOut;
```
自己被禁言时回调
```Objective-C
/**
*  自己被禁言时回调
*
*/
- (void)onSelfSilenced:(NSInteger)hour;
```
自己恢复禁言时回调
```Objective-C
/**
*  自己恢复禁言时回调
*
*/
- (void)onSelfUnSilence;
```
对讲服务连接成功后回调
```Objective-C
/**
*  对讲服务连接成功后回调 表示可以正常收听语音消息
*
*  @param onlineSize  房间在线人数
*  @param totalSize  房间总人数
*/
- (void)onTalkieServerConnectedOnlineSize:(NSInteger)onlineSize totalSize:(NSInteger)totalSize;
```
对讲服务断开后回调
```Objective-C
/**
*  对讲服务断开后回调 表示自己已离线（无法收听语音消息）如果是offline或logout或登录冲突则不会自动连接 需手动执行online操作才能再次连接
*
*/
- (void)onTalkieServerDisconnected;
```

<h3>memberDelegate</h3>

其它用户开始发言事件
```Objective-C
/**
*  其它用户开始发言事件
*
*  @param openId  用户openId
*/
- (void)onMemberStartSpeak:(NSString*)openId;
```
其它用户结束发言事件
```Objective-C
/**
*  其它用户结束发言事件
*
*  @param openId  用户openId
*/
- (void)onMemberStopSpeak:(NSString*)openId;
```
其它用户位置变更事件
```Objective-C
/**
*  其它用户位置变更事件
*
*  @param openId  用户openId
*  @param lat  纬度
*  @param lon  经度
*  @param speed  速度
*  @param direction  方向
*/
- (void)onMemberLocationChangeOpenId:(NSString*)openId latitude:(CGFloat)lat longitude:(CGFloat)lon speed:(CGFloat)speed direction:(CGFloat)direction;
```
其他用户角色改变时
```Objective-C
/**
*  其他用户角色改变时
*
*  @param openId  用户openId
*  @param roomRole  角色
*/
- (void)onMemberRoleChangeOpenId:(NSString*)openId roomRole:(RoomRole)roomRole;
```
其他用户上线时
```Objective-C
/**
*  其他用户上线时
*
*  @param openId  用户openId
*  @param onlineSize  房间在线人数
*  @param totalSize  房间总人数
*/
- (void)onMemberOnlineOpenId:(NSString*)openId onlineSize:(NSInteger)onlineSize totalSize:(NSInteger)totalSize;
```
其他用户下线时
```Objective-C
/**
*  其他用户下线时
*
*  @param openId  用户openId
*  @param onlineSize  房间在线人数
*  @param totalSize  房间总人数
*/
- (void)onMemberOfflineOpenId:(NSString*)openId onlineSize:(NSInteger)onlineSize totalSize:(NSInteger)totalSize;
```
其他用户退出房间时
```Objective-C
/**
*  其他用户退出房间时
*
*  @param openId  用户openId
*  @param onlineSize  房间在线人数
*  @param totalSize  房间总人数
*/
- (void)onMemberLeaveOpenId:(NSString*)openId onlineSize:(NSInteger)onlineSize totalSize:(NSInteger)totalSize;
```
其他用户更改房间名称时
```Objective-C
/**
*  其他用户更改房间名称时
*
*  @param openId  用户openId
*  @param roomName  房间名
*/
- (void)onMemberChangerRoomNameOpenId:(NSString*)openId roomName:(NSString*)roomName;
```
其他用户打开位置共享
```Objective-C
/**
*  其他用户打开位置共享
*
*  @param openId  用户openId
*/
- (void)onMemberOpenLocationSharingChange:(NSString*)openId;
```
其他用户关闭位置共享
```Objective-C
/**
*  其他用户关闭位置共享
*
*  @param openId  用户openId
*/
- (void)onMemberCloseLocationSharingChange:(NSString*)openId;
```

<h2 id="类说明">四、类说明</h2>

<h3>实体类</h3>

1.房间信息 EDRoomInfo
```Objective-C
/**
*  唯一标识
*/
@property (nonatomic, strong) NSString *nid;
/**
*  名称
*/
@property (nonatomic, strong) NSString *name;
/**
*  在线人数
*/
@property (nonatomic, assign) NSInteger onlineSize;
/**
*  总人数
*/
@property (nonatomic, assign) NSInteger totalSize;
/**
*  位置共享开关: 1.共享 0.不共享
*/
@property (nonatomic, assign) BOOL locationSharing;
/**
*  自己的数据
*/
@property (nonatomic, strong) EDUserInfo *selfModel;
```

2.用户信息 EDUserInfo
```Objective-C
/**
*  唯一标识
*/
@property (nonatomic, strong) NSString *nid;

/**
*  角色
*/
@property (nonatomic, assign) RoomRole role;

/**
*  上线/离线
*/
@property (nonatomic) BOOL isOnline;

/**
*  房间权限 EDIntercomRoomPrivilege
*/
@property (nonatomic, strong) NSArray *privileges;

/**
*  是否是自己
*/
@property (nonatomic, assign) BOOL isSelf;
```

<h3>枚举</h3>

1.发言状态
```Objective-C
typedef enum{
MicrophoneState_ERROR = 0,//错误(检查是否配置了ImService)
IntercomState_LEISURE,//空闲
IntercomState_REQUEST_SPEAKING,//正在请求发言中
IntercomState_SELF_SPEAKING,//自己正在发言
IntercomState_MEMBER_SPEAKING //其他人员正在发言
} MicrophoneState;
```

2.房间角色
```Objective-C
typedef enum {
RoomRole_OWNER = 0,          //群主
RoomRole_ADMINISTRATOR = 11, //管理员
RoomRole_GENERAL_MEMBER = 51 //普通成员
}RoomRole;
```

3.停止说话类型
```Objective-C
typedef enum {
StopSpeakType_BY_HAND = 0,                 //手动丢麦
StopSpeakType_BY_HIGHER_PERMISSION,        //更高的请求发言的权限打断
StopSpeakType_BY_SERVER_NO_RECEIVER_AUDIO, //服务端一段时间未收到语音包 强制打断
StopSpeakType_BY_SPEAK_TIME_OUT,           //发言时长达到最大值 服务端强制打断
StopSpeakType_BY_AUTO,                     //抢麦3秒无发言自动丢麦(群主除外)
StopSpeakType_BY_SOCKET_SERVER_DISCONNECT  //网络不稳定时 Socket服务断开时 强制打断
}StopSpeakType;
```

4.用户权限
```Objective-C
typedef NS_ENUM(NSInteger, EDIntercomRoomPrivilege) {
// 1 普通用户在房间内的操作权限定义
AllowSpeakPrivilege                 =   1001,   // 允许发言
AllowChangeRoomNamePrivilege        =   1002,   // 允许修改房间名称
AllowChangeDestinationPrivilege     =   1003,   // 允许修改房间目的地
AllowInviteUserPrivilege            =   1004,   // 允许邀请好友

// 2 管理员对单个用户的管理操作定义
AllowKickUserPrivilege              =   2001,   // 允许将用户踢出房间
AllowMuteUserPrivilege              =   2002,   // 允许将用户禁言
AllowUnmuteUserPrivilege            =   2003,   // 允许恢复用户发言

// 3 管理员对整个房间的管理操作定义
AllowChangePeopleNumberPrivilege    =   3001,   // 允许修改房间人数上限
AllowChangeSpeakTimePrivilege       =   3002,   // 允许修改房间发言时长
AllowDisableSpeakPrivilege          =   3003,   // 允许禁止房间内所有普通用户发言
AllowDeleteRoomPrivilege            =   3004    // 允许删除/解散房间
};
```
