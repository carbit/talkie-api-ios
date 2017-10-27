//
//  ChannelOperateViewController.m
//  EasyconnTalkieDemo
//
//  Created by ch on 2017/6/7.
//  Copyright © 2017年 carbit. All rights reserved.
//

#import "ChannelOperateViewController.h"
#import "MemberViewController.h"
#import "Reachability.h"
#import <AVFoundation/AVFoundation.h>

@interface ChannelOperateViewController ()<UITableViewDelegate,UITableViewDataSource,EDTalkieManagerSelfDelegate,EDTalkieManagerMemberDelegate,AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *roomNameTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *totalNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlineNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakStatus;
@property (weak, nonatomic) IBOutlet UILabel *isOnlineLabel;
@property (weak, nonatomic) IBOutlet UITableView *userMemberTableView;
@property (weak, nonatomic) IBOutlet UITextField *volumeTextField;
@property (nonatomic,strong) NSTimer *statusTimer;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (nonatomic,strong) NSMutableArray<EDUserInfo> *listArray;
@property (nonatomic,strong) AVAudioPlayer *player;
@end

@implementation ChannelOperateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.roomId;
    [EDTalkieManager shareInstance].selfDelegate = self;
    [EDTalkieManager shareInstance].memberDelegate = self;
    self.userMemberTableView.delegate = self;
    self.userMemberTableView.dataSource = self;
    self.listArray = [NSMutableArray array];
    [self getRoomInfo];
    self.statusTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(reloadStatus) userInfo:nil repeats:YES];
    [self.statusTimer fire];
    // Do any additional setup after loading the view.
}

- (void)getRoomInfo{
    [[EDTalkieManager shareInstance] getRoomInfo:self.roomId callback:^(EDRoomInfo *roomInfo, NSError *error) {
        if (!error&&roomInfo) {
            NSLog(@"roomInfo:%@",roomInfo);
            NSLog(@"当前线程%@",[NSThread currentThread]);
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.roomNameTextFiled.text = roomInfo.name;
                self.totalNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)roomInfo.totalSize];
                self.onlineNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)roomInfo.onlineSize];
            });
        }else{
            NSLog(@"error:%@",error);
        }
    }];
}

- (IBAction)speak:(id)sender {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == NotReachable) {
        [SVProgressHUD showInfoWithStatus:@"请检查网络"];
        return;
    }
    [[EDTalkieManager shareInstance] requestSpeakWithResult:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.description];
            NSError *err;
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"抢麦失败" withExtension:@"wav"] error:&err];
            self.player.volume = 1.0;
            self.player.rate = 1.0;
            [self.player play];
        }else{
            NSError *err;
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"开始识别" withExtension:@"wav"] error:&err];
            self.player.volume = 1.0;
            self.player.rate = 1.0;
            [self.player play];
        }
    }];
}

- (IBAction)stopSpeak:(id)sender {
    [[EDTalkieManager shareInstance] stopSpeak];
}

- (IBAction)setVloume:(id)sender {
    CGFloat vloume = [self.volumeTextField.text floatValue];
    if (vloume<0||vloume>1) {
        [SVProgressHUD showInfoWithStatus:@"音量只能设置在0~1"];
    }else{
        [[EDTalkieManager shareInstance] setTalkieVolume:[self.volumeTextField.text floatValue]];
        self.volumeLabel.text = [NSString stringWithFormat:@"音量:%@",self.volumeTextField.text];
    }
}

- (IBAction)uploadLocation:(id)sender {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == NotReachable) {
        [SVProgressHUD showInfoWithStatus:@"请检查网络"];
        return;
    }
    [[EDTalkieManager shareInstance] uploadLocationWithLat:30.5 lon:114.39 speed:2 direction:0];
}
- (IBAction)leaveRoom:(id)sender {
    [[EDTalkieManager shareInstance] leaveRoom:self.roomId callback:^(NSError *error) {
        if (error) {
            NSLog(@"leaveRoomError:%@",error);
            [SVProgressHUD showErrorWithStatus:error.description];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"离开房间"];
            NSLog(@"当前线程%@",[NSThread currentThread]);
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}
- (IBAction)openLocationShare:(id)sender {
    [[EDTalkieManager shareInstance] setLocationSharing:YES roomId:self.roomId callback:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
            [SVProgressHUD showErrorWithStatus:error.description];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"共享开"];
        }
    }];
    
}
- (IBAction)closeLocationShare:(id)sender {
    [[EDTalkieManager shareInstance] setLocationSharing:NO roomId:self.roomId callback:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
            [SVProgressHUD showErrorWithStatus:error.description];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"共享关"];
        }
    }];
}
- (IBAction)online:(id)sender {
    [[EDTalkieManager shareInstance] online:self.roomId callback:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.description];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"上线成功"];
            [GlobalEntity sharedInstance].activeRoomId = self.roomId;
        }
    }];
}
- (IBAction)offline:(id)sender {
    [[EDTalkieManager shareInstance] offline];
    if ([GlobalEntity sharedInstance].activeRoomId) {
        [SVProgressHUD showSuccessWithStatus:@"下线成功"];
        [GlobalEntity sharedInstance].activeRoomId = nil;
    }else{
        [SVProgressHUD showInfoWithStatus:@"当前还不在房间内"];
    }
}
- (IBAction)changeRoomName:(id)sender {
    [[EDTalkieManager shareInstance] setRoomName:self.roomNameTextFiled.text roomId:self.roomId callback:^(NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"群名称修改成功"];
        }else{
            [SVProgressHUD showInfoWithStatus:error.description];
        }
    }];
}

- (IBAction)groupMember:(id)sender {
    [[EDTalkieManager shareInstance] getUserList:self.roomId page:0 size:20 callback:^(NSArray<EDUserInfo> *userInfoList, NSError *error) {
        if (!error&&userInfoList) {
            [self.listArray removeAllObjects];
            for (EDUserInfo *userInfo in userInfoList) {
                [self.listArray addObject:userInfo];
            }
            NSLog(@"当前线程%@",[NSThread currentThread]);
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.userMemberTableView reloadData];
            });
        }else{
            [SVProgressHUD showErrorWithStatus:error.description];
        }
    }];
}

- (void)reloadStatus{
    switch ([[EDTalkieManager shareInstance] getSpeakState]) {
        case IntercomState_LEISURE:
        {
            self.speakStatus.text = @"正常状态";
        }
            break;
        case IntercomState_MEMBER_SPEAKING:
        {
            self.speakStatus.text = @"别人正在讲话";
        }
            break;
        case IntercomState_REQUEST_SPEAKING:
        {
            self.speakStatus.text = @"抢麦中";
        }
            break;
        case IntercomState_SELF_SPEAKING:
        {
            self.speakStatus.text = @"正在说话中";
        }
            break;
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ideitifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ideitifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ideitifier];
    }
    EDUserInfo *userInfo = self.listArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"用户ID:%@,%@,%d",userInfo.nid,userInfo.isOnline?@"在线":@"离线",userInfo.role];
    if ([userInfo.nid isEqualToString:[GlobalEntity sharedInstance].openId]) {
        cell.textLabel.textColor = [UIColor redColor];
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EDUserInfo *userInfo = self.listArray[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MemberViewController *mvc = [storyboard instantiateViewControllerWithIdentifier:@"memberVC"];
    mvc.roomId = self.roomId;
    mvc.memberUserId = userInfo.nid;
    [self.navigationController pushViewController:mvc animated:YES];
}

- (void)onSelfStopSpeak:(StopSpeakType)stopSpeakType{
    NSError *err;
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"识别完成" withExtension:@"wav"] error:&err];
    self.player.volume = 1.0;
    self.player.rate = 1.0;
    [self.player play];
    switch (stopSpeakType) {
        case StopSpeakType_BY_HAND:
        {
            [SVProgressHUD showInfoWithStatus:@"手动丢麦"];
        }
            break;
        case StopSpeakType_BY_HIGHER_PERMISSION:
        {
            [SVProgressHUD showInfoWithStatus:@"更高的请求发言的权限打断"];
        }
            break;
        case StopSpeakType_BY_SERVER_NO_RECEIVER_AUDIO:
        {
            [SVProgressHUD showInfoWithStatus:@"服务端一段时间未收到语音包 强制打断"];
        }
            break;
        case StopSpeakType_BY_SPEAK_TIME_OUT:
        {
            [SVProgressHUD showInfoWithStatus:@"发言时长达到最大值 服务端强制打断"];
        }
            break;
        case StopSpeakType_BY_AUTO:
        {
            [SVProgressHUD showInfoWithStatus:@"抢麦3秒无发言自动丢麦(群主除外)"];
        }
            break;
        case StopSpeakType_BY_SOCKET_SERVER_DISCONNECT:
        {
            [SVProgressHUD showInfoWithStatus:@"网络不稳定时 Socket服务断开时 强制打断"];
        }
            break;
            
        default:
            break;
    }
}

- (void)onSelfRoleChange:(RoomRole)roomRole{
    switch (roomRole) {
        case RoomRole_OWNER:
        {
            [SVProgressHUD showInfoWithStatus:@"自己的角色被改变为群主"];
        }
            break;
        case RoomRole_ADMINISTRATOR:
        {
            [SVProgressHUD showInfoWithStatus:@"自己的角色被改变为管理员"];
        }
            break;
        case RoomRole_GENERAL_MEMBER:
        {
            [SVProgressHUD showInfoWithStatus:@"自己的角色被改变为普通成员"];
        }
            break;
        default:
            break;
    }
}

- (void)onSelfKickOut{
    [SVProgressHUD showInfoWithStatus:@"自己被踢出当前房间"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSelfSilenced:(NSInteger)hour{
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"自己被禁言%ld小时",(long)hour]];
}

- (void)onSelfUnSilence{
    [SVProgressHUD showInfoWithStatus:@"自己恢复禁言"];
}

- (void)onTalkieServerConnectedOnlineSize:(NSInteger)onlineSize totalSize:(NSInteger)totalSize{
    [SVProgressHUD showInfoWithStatus:@"对讲服务连接成功 表示可以正常收听语音消息"];
}

- (void)onTalkieServerDisconnected{
    [SVProgressHUD showInfoWithStatus:@"对讲服务断开"];
}


- (void)onMemberStartSpeak:(NSString*)openId{
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"用户%@开始发言",openId]];
}

//其它用户结束发言事件
- (void)onMemberStopSpeak:(NSString*)openId{
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"用户%@结束发言",openId]];
}

- (void)onMemberLocationChangeOpenId:(NSString*)openId latitude:(CGFloat)lat longitude:(CGFloat)lon speed:(CGFloat)speed direction:(CGFloat)direction{
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"用户%@位置变更",openId]];
}
- (void)onMemberRoleChangeOpenId:(NSString*)openId roomRole:(RoomRole)roomRole{
    switch (roomRole) {
        case RoomRole_OWNER:
        {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"用户%@角色改变被改变为群主",openId]];
        }
            break;
        case RoomRole_ADMINISTRATOR:
        {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"用户%@角色改变被改变为管理员",openId]];
        }
            break;
        case RoomRole_GENERAL_MEMBER:
        {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"用户%@角色改变被改变为普通成员",openId]];
        }
            break;
        default:
            break;
    }
}

- (void)onMemberOnlineOpenId:(NSString*)openId onlineSize:(NSInteger)onlineSize totalSize:(NSInteger)totalSize{
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"用户%@上线",openId]];
    self.onlineNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)onlineSize];
    self.totalNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)totalSize];
}

- (void)onMemberOfflineOpenId:(NSString*)openId onlineSize:(NSInteger)onlineSize totalSize:(NSInteger)totalSize{
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"用户%@下线",openId]];
    self.onlineNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)onlineSize];
    self.totalNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)totalSize];
}

- (void)onMemberLeaveOpenId:(NSString*)openId onlineSize:(NSInteger)onlineSize totalSize:(NSInteger)totalSize{
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"用户%@退出房间",openId]];
    self.onlineNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)onlineSize];
    self.totalNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)totalSize];
}

- (void)onMemberChangerRoomNameOpenId:(NSString*)openId roomName:(NSString*)roomName{
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"用户%@更改房间名称",openId]];
    self.roomNameTextFiled.text = roomName;
}

- (void)onMemberOpenLocationSharingChange:(NSString*)openId{
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"用户%@打开位置共享",openId]];
}

- (void)onMemberCloseLocationSharingChange:(NSString*)openId{
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"用户%@关闭位置共享",openId]];
}

//- (AVAudioPlayer *)player{
//    if (!_player) {
//        _player = [[AVAudioPlayer alloc] init];
////        _player.delegate = self;
//        _player.rate = 1.0;
//    }
//    return _player;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
