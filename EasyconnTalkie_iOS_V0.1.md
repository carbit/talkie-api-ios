#对讲服务接入说明iOS V0.1


##一、工程配置说明

###新建工程，引入EasyconnTalkie.framework 

##二、接口说明

###1.登录服务器
```Objective-C
/**
 *  登陆服务器，获取openID
 *
 *  @param appID  分配的appID
 *  @param userID  用户ID，由调用者产生或分配
 *  @param callback  连接结果回调,error:错误信息，为nil时表示成功;openID:对讲账户体系对应的用户ID
 */
- (void)loginWithAppID:(NSString *)appID userID:(NSString *)userID callback:(void(^)(NSError *error,NSString *openID))callback;
```


###2.对讲上线
```Objective-C
/**
 *  对讲上线，上线之后可进行对讲和收听对讲
 *  @param roomID  房间号
 *  @param callback 上线结果回调,error:错误信息，为nil时表示成功
 */
- (void)online:(NSString *)roomID callback:(void(^)(NSError *error))callback;
```


###3.对讲下线
```Objective-C
/**
 *  对讲下线
 */
- (void)offline;
```


###4.请求发言
```Objective-C
/**
 *  请求发言
 *  @param callback 请求结果回调,error:错误信息，为nil时表示成功
 */
- (void)requestSpeakWithResult:(void(^)(NSError *error))callback;
```


###5.结束发言
```Objective-C
/**
 *  结束发言
 */
- (void)stopSpeak;
```


###6.上传位置信息
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


###7.监听其他用户位置更新
```Objective-C
/**
 *  监听其他用户位置更新
 *  @param callback 监听回调
 */
- (void)listeningOtherUserLocationChanged:(void(^)(NSString *openID,CGFloat lat,CGFloat lon,CGFloat speed,CGFloat direction))callback;
```


###8.监听其他用户开始发言
```Objective-C
/**
 *  监听其他用户开始发言
 *  @param callback 监听回调
 */
- (void)listeningOtherUserStartSpeak:(void(^)(NSString *openID))callback;
```


###9.监听其他用户停止发言
```Objective-C
/**
 *  监听其他用户停止发言
 *  @param callback 监听回调
 */
- (void)listeningOtherUserStopSpeak:(void(^)(NSString *openID))callback;
```


###10.监听对讲连接状态
```Objective-C
/**
 *  监听连接状态
 *  @param callback 监听回调
 */
- (void)listeningConnectState:(void(^)(ConnectState state))callback;
```

###11.设置对讲播放的音量
```Objective-C
/**
*  设置对讲播放的音量
*  @param volume 音量值，取值范围[0,1]，设置其他值时无效
*/
- (void)setTalkieVolume:(CGFloat)volume;
```
