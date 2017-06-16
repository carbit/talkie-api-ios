//
//  MemberViewController.m
//  EasyconnTalkieDemo
//
//  Created by ch on 2017/6/8.
//  Copyright © 2017年 carbit. All rights reserved.
//

#import "MemberViewController.h"

@interface MemberViewController ()

@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.memberUserId;
    // Do any additional setup after loading the view.
}
- (IBAction)setAdmin:(id)sender {
    [[EDTalkieManager shareInstance] setRoomRoleWithRoomId:self.roomId openId:self.memberUserId role:RoomRole_ADMINISTRATOR callback:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
            [SVProgressHUD showErrorWithStatus:error.description];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
        }
    }];
}

- (IBAction)setMember:(id)sender {
    [[EDTalkieManager shareInstance] setRoomRoleWithRoomId:self.roomId openId:self.memberUserId role:RoomRole_GENERAL_MEMBER callback:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
            [SVProgressHUD showErrorWithStatus:error.description];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
        }
    }];
}

- (IBAction)slience:(id)sender {
    [[EDTalkieManager shareInstance] silencedUserWithRoomId:self.roomId userIdArray:@[self.memberUserId] action:@"add" hour:2 callback:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
            [SVProgressHUD showErrorWithStatus:error.description];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
        }
    }];
}

- (IBAction)getOut:(id)sender {
    [[EDTalkieManager shareInstance] kickUserWithRoomId:self.roomId userIdArray:@[self.memberUserId] action:@"add" hour:24 callback:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
            [SVProgressHUD showErrorWithStatus:error.description];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
        }
    }];
}

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
