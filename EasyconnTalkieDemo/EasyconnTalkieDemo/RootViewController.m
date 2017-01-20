//
//  RootViewController.m
//  EasyconnTalkieDemo
//
//  Created by wzt on 2017/1/19.
//  Copyright © 2017年 carbit. All rights reserved.
//

#import "RootViewController.h"

#import <EasyconnTalkie/EasyconnTalkie.h>

@interface RootViewController ()

@property(nonatomic,strong)UITextView *msgTv;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller.
    //
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
    
    [self setListening];
    
    [self addShowMessage:@"请求服务器授权..."];
    
    NSString *appID = nil;//appID测试期间可传nil
    [[TalkieManager shareInstance] loginWithAppID:appID userID:@"128349" callback:^(NSError *error, NSString *openID) {
        if (!error) {
            [self addShowMessage:[NSString stringWithFormat:@"授权成功，openID:%@",openID]];
        }
        else {
            [self addShowMessage:[NSString stringWithFormat:@"%@",error]];
        }
    }];
}

- (void)initUI
{
    self.msgTv = [[UITextView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height*0.5)];
    self.msgTv.textColor = [UIColor whiteColor];
    self.msgTv.layoutManager.allowsNonContiguousLayout = NO;
    self.msgTv.editable = NO;
    self.msgTv.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.msgTv];
    
    CGFloat buttonWith = (self.view.frame.size.width-80.0)/3.0;
    
    UIButton *onlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    onlineButton.frame = CGRectMake(20, self.msgTv.frame.size.height+50, buttonWith, 40);
    onlineButton.backgroundColor = [UIColor lightGrayColor];
    [onlineButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [onlineButton setTitle:@"上线" forState:UIControlStateNormal];
    [onlineButton addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    onlineButton.tag = 1001;
    [self.view addSubview:onlineButton];
    
    UIButton *offlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    offlineButton.frame = CGRectMake(buttonWith+40, self.msgTv.frame.size.height+50, buttonWith, 40);
    offlineButton.backgroundColor = [UIColor lightGrayColor];
    [offlineButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [offlineButton setTitle:@"下线" forState:UIControlStateNormal];
    [offlineButton addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    offlineButton.tag = 1002;
    [self.view addSubview:offlineButton];
    
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.frame = CGRectMake(buttonWith*2+60, self.msgTv.frame.size.height+50, buttonWith, 40);
    locationButton.backgroundColor = [UIColor lightGrayColor];
    [locationButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [locationButton setTitle:@"上传位置" forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    locationButton.tag = 1003;
    [self.view addSubview:locationButton];
    
    
    UIButton *speakButton = [UIButton buttonWithType:UIButtonTypeCustom];
    speakButton.frame = CGRectMake((self.view.frame.size.width - buttonWith)/2, self.view.frame.size.height-buttonWith-30, buttonWith, buttonWith);
    speakButton.backgroundColor = [UIColor blueColor];
    [speakButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [speakButton setImage:[UIImage imageNamed:@"地图对讲"] forState:UIControlStateNormal];
    [speakButton addTarget:self action:@selector(requestSpeak) forControlEvents:UIControlEventTouchDown];
    [speakButton addTarget:self action:@selector(stopSpeak) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:speakButton];
}

- (void)addShowMessage:(NSString *)msg
{
    self.msgTv.text = [NSString stringWithFormat:@"%@%@\n",self.msgTv.text,msg];
    [self.msgTv scrollRangeToVisible:NSMakeRange(self.msgTv.text.length, 1)];
}

- (void)buttonEvent:(UIButton *)sender
{
    switch (sender.tag) {
        case 1001:
        {
            [self addShowMessage:@"上线中..."];
            [[TalkieManager shareInstance] online:^(NSError *error) {
                if (!error) {
                    [self addShowMessage:@"上线成功！"];
                }
                else {
                    [self addShowMessage:[NSString stringWithFormat:@"%@",error]];
                }
            }];
        }
            break;
        case 1002:
        {
            [[TalkieManager shareInstance] offline];
            [self addShowMessage:@"下线成功！"];
        }
            break;
        case 1003:
        {
            [self addShowMessage:@"上传位置信息"];
            [[TalkieManager shareInstance] uploadLocationWithLat:0.0 lon:0.0 speed:0.0 direction:-1.0];
        }
            break;
            
        default:
            break;
    }
}

- (void)requestSpeak
{
    [self addShowMessage:@"请求发言..."];
    [[TalkieManager shareInstance] requestSpeakWithResult:^(NSError *error) {
        if (!error) {
            [self addShowMessage:@"请求成功，请开始说话..."];
        }
        else {
            [self addShowMessage:[NSString stringWithFormat:@"%@",error]];
        }
    }];
}

- (void)stopSpeak
{
    [self addShowMessage:@"主动停止发言！"];
    [[TalkieManager shareInstance] stopSpeak];
}

- (void)setListening
{
    [[TalkieManager shareInstance] listeningConnectState:^(ConnectState state) {
        if (state == ConnectStateConnected) {
            [self addShowMessage:@"连接成功！"];
        }
        else if (state == ConnectStateDisconnect) {
            [self addShowMessage:@"断开连接！"];
        }
    }];
    
    [[TalkieManager shareInstance] listeningOtherUserStartSpeak:^(NSString *openID) {
        [self addShowMessage:[NSString stringWithFormat:@"用户开始发言，openID:%@",openID]];
    }];
    
    [[TalkieManager shareInstance] listeningOtherUserStopSpeak:^(NSString *openID) {
        [self addShowMessage:[NSString stringWithFormat:@"用户停止发言，openID:%@",openID]];
    }];
    
    [[TalkieManager shareInstance] listeningOtherUserLocationChanged:^(NSString *openID, CGFloat lat, CGFloat lon, CGFloat speed, CGFloat direction) {
        [self addShowMessage:[NSString stringWithFormat:@"用户位置信息更新，openID:%@,lat:%f,lon:%f,speed:%f,direction:%f",openID,lat,lon,speed,direction]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
