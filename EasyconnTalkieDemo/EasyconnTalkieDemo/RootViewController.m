//
//  RootViewController.m
//  EasyconnTalkieDemo
//
//  Created by wzt on 2017/1/19.
//  Copyright © 2017年 carbit. All rights reserved.
//

#import "RootViewController.h"
#import "MainChannelViewController.h"

@interface RootViewController ()
@property (weak, nonatomic) IBOutlet UITextField *appIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *userIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *secretTextField;
@property (weak, nonatomic) IBOutlet UILabel *openIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *userOpenIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *tokenLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTokenLabel;
@property (weak, nonatomic) IBOutlet UIButton *oauthLoginLabel;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (nonatomic,assign) BOOL isSDKRuning;

@property(nonatomic,strong)UITextView *msgTv;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseView.hidden = YES;
    self.title = @"首页";
    [EDTalkieManager setLog:YES];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    [self setListening];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self checkTokenView];
}

- (IBAction)initSDK:(id)sender {
    if (!self.isSDKRuning) {
        [EDTalkieManager initWithAppId:self.appIdTextField.text];
//        [SVProgressHUD showSuccessWithStatus:@"初始化成功"];
        self.baseView.hidden = NO;
        self.isSDKRuning = YES;
    }else{
        [SVProgressHUD showInfoWithStatus:@"SDK已初始化"];
    }
}

- (IBAction)destorySDK:(id)sender {
    if (self.isSDKRuning) {
        [SVProgressHUD showSuccessWithStatus:@"销毁服务"];
        self.baseView.hidden = YES;
        self.isSDKRuning = NO;
    }else{
        [SVProgressHUD showInfoWithStatus:@"SDK还没初始化"];
    }
}

- (IBAction)loginSDK:(id)sender {
    if (self.isSDKRuning) {
        weakify_self
        [[EDTalkieManager shareInstance] loginWithSecret:self.secretTextField.text userID:self.userIdTextField.text callback:^(NSError *error, NSString *token, NSString *openID) {
            strongify_self
            if (!error) {
                NSLog(@"登录服务器成功，openID:%@",openID);
                [SVProgressHUD showSuccessWithStatus:@"登录服务器成功"];
                [GlobalEntity sharedInstance].token = token;
                [GlobalEntity sharedInstance].openId = openID;
                [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
                [[NSUserDefaults standardUserDefaults] setObject:openID forKey:@"openID"];
                NSLog(@"当前线程%@",[NSThread currentThread]);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    MainChannelViewController *mcVC = [storyboard instantiateViewControllerWithIdentifier:@"mainChannelVC"];
                    [self.navigationController pushViewController:mcVC animated:YES];
                });
            }
            else {
                NSLog(@"%@",error);
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            }
        }];
    }else{
        [SVProgressHUD showInfoWithStatus:@"SDK还没初始化"];
    }
}

- (IBAction)oauthLogin:(id)sender {
    weakify_self
    [[EDTalkieManager shareInstance] oauthWithToken:self.userTokenLabel.text openId:self.userOpenIdLabel.text callback:^(NSError *error) {
        strongify_self
        if (!error) {
            NSLog(@"授权登录服务器成功，openID:%@",self.userTokenLabel.text);
            [SVProgressHUD showSuccessWithStatus:@"授权登录服务器成功"];
            [GlobalEntity sharedInstance].token = self.userTokenLabel.text;
            [GlobalEntity sharedInstance].openId = self.userOpenIdLabel.text;
            NSLog(@"当前线程%@",[NSThread currentThread]);
            dispatch_sync(dispatch_get_main_queue(), ^{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MainChannelViewController *mcVC = [storyboard instantiateViewControllerWithIdentifier:@"mainChannelVC"];
                [self.navigationController pushViewController:mcVC animated:YES];
            });
        }
        else {
            NSLog(@"%@",error);
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }
    }];
}

- (BOOL)checkIsLogin{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]){
        return YES;
    }else{
        return NO;
    }
}

- (void)pustToMainChannelVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainChannelViewController *mcVC = [storyboard instantiateViewControllerWithIdentifier:@"mainChannelVC"];
    [self.navigationController pushViewController:mcVC animated:YES];
}

- (void)checkTokenView{
    if ([self checkIsLogin]) {
        self.tokenLabel.hidden = NO;
        self.openIdLabel.hidden = NO;
        self.userTokenLabel.hidden = NO;
        self.userOpenIdLabel.hidden = NO;
        self.oauthLoginLabel.hidden = NO;
        self.userTokenLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        self.userOpenIdLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"openID"];
    }else{
        self.oauthLoginLabel.hidden = YES;
        self.tokenLabel.hidden = YES;
        self.openIdLabel.hidden = YES;
        self.userTokenLabel.hidden = YES;
        self.userOpenIdLabel.hidden = YES;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)requestSpeak
{
    
}

- (void)stopSpeak
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
