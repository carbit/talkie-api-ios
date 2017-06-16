//
//  MainChannelViewController.m
//  EasyconnTalkieDemo
//
//  Created by ch on 2017/6/6.
//  Copyright © 2017年 carbit. All rights reserved.
//

#import "MainChannelViewController.h"
#import "ChannelOperateViewController.h"

@interface MainChannelViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *muteLabel;
@property (weak, nonatomic) IBOutlet UILabel *openIdLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *channelidLabel;
@property (weak, nonatomic) IBOutlet UILabel *tokenLabel;
@property (weak, nonatomic) IBOutlet UITableView *roomListTableView;
@property (nonatomic,strong) NSMutableArray<EDRoomInfo> *listArray;
@end

@implementation MainChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"频道列表";
    self.tokenLabel.text = [GlobalEntity sharedInstance].token;
    self.openIdLabel.text = [GlobalEntity sharedInstance].openId;
    self.roomListTableView.delegate = self;
    self.roomListTableView.dataSource = self;
    self.listArray = [NSMutableArray array];
    [self.roomListTableView reloadData];
    [self getGmute];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [self startRoomListPolling:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self stopRoomListPolling:nil];
}

- (void)getGmute{
    weakify_self
    [[EDTalkieManager shareInstance] getGlobalSetting:^(NSError *error, BOOL gMute) {
        if (!error) {
            strongify_self
            NSLog(@"当前线程%@",[NSThread currentThread]);
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (gMute) {
                    self.muteLabel.text = @"静音中";
                }else{
                    self.muteLabel.text = @"静音关闭";
                }
            });
            
        }
    }];
}

- (IBAction)gMute:(id)sender {
    weakify_self
    [[EDTalkieManager shareInstance] setGlobalMute:YES callback:^(NSError *error) {
        strongify_self
        if (error) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error.description]];
        }else{
            NSLog(@"当前线程%@",[NSThread currentThread]);
            dispatch_sync(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"设置静音成功"];
                self.muteLabel.text = @"静音中";
            });
        }
    }];
}

- (IBAction)ungMute:(id)sender {
    [[EDTalkieManager shareInstance] setGlobalMute:NO callback:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error.description]];
        }else{
            NSLog(@"当前线程%@",[NSThread currentThread]);
            dispatch_sync(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"关闭静音成功"];
                self.muteLabel.text = @"静音关闭";
            });
        }
    }];
}

- (IBAction)createChannel:(id)sender {
    [self.nameTextField resignFirstResponder];
    weakify_self
    [[EDTalkieManager shareInstance] createRoom:self.nameTextField.text callback:^(NSError *error, EDRoomInfo *roomInfo) {
        strongify_self
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.description];
            NSLog(@"建群失败:%@",error.description);
        }else{
            NSLog(@"成功创建群%@",roomInfo);
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"成功创建群%@",roomInfo.nid]];
            NSLog(@"当前线程%@",[NSThread currentThread]);
            dispatch_sync(dispatch_get_main_queue(), ^{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ChannelOperateViewController *mcVC = [storyboard instantiateViewControllerWithIdentifier:@"channelOperateVC"];
                mcVC.roomId = roomInfo.nid;
                [GlobalEntity sharedInstance].activeRoomId = mcVC.roomId;
                [self.navigationController pushViewController:mcVC animated:YES];
            });
        }
    }];
}


- (IBAction)joinChannel:(id)sender {
    [self.channelidLabel resignFirstResponder];
    [self joinChannelWithRoomId:self.channelidLabel.text];
}

- (void)joinChannelWithRoomId:(NSString*)roomId{
    weakify_self
    [[EDTalkieManager shareInstance] online:roomId callback:^(NSError *error) {
        strongify_self
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.description];
        }else{
            NSLog(@"当前线程%@",[NSThread currentThread]);
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ChannelOperateViewController *mcVC = [storyboard instantiateViewControllerWithIdentifier:@"channelOperateVC"];
            mcVC.roomId = roomId;
            [GlobalEntity sharedInstance].activeRoomId = mcVC.roomId;
            [self.navigationController pushViewController:mcVC animated:YES];
        }
    }];
}

- (IBAction)isValidToken:(id)sender {
    [[EDTalkieManager shareInstance] oauthWithToken:[GlobalEntity sharedInstance].token openId:[GlobalEntity sharedInstance].openId callback:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.description];
            NSLog(@"校验失败:%@",error.description);
        }else{
            [SVProgressHUD showSuccessWithStatus:@"校验成功"];
        }
    }];
}

- (IBAction)startRoomListPolling:(id)sender {
    weakify_self
    [[EDTalkieManager shareInstance] setRoomListPollingListener:10 callback:^(NSError *error, NSArray<EDRoomInfo> *roomInfoList) {
        strongify_self
        if (roomInfoList) {
            NSLog(@"roomInfoList:%@",roomInfoList);
            [self.listArray removeAllObjects];
            for (EDRoomInfo *roomInfo in roomInfoList) {
                [self.listArray addObject:roomInfo];
            }
            NSLog(@"当前线程%@",[NSThread currentThread]);
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.roomListTableView reloadData];
            });
        }else{
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }
    }];
}

- (IBAction)stopRoomListPolling:(id)sender {
    [[EDTalkieManager shareInstance] stopRoomListPolling];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ideitifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ideitifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ideitifier];
    }
    EDRoomInfo *roomInfo = self.listArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld:群名称%@ 总人数%ld 在线人数%ld 群ID:%@",(long)indexPath.row,roomInfo.name,(long)roomInfo.totalSize,(long)roomInfo.onlineSize,roomInfo.nid];
    if ([roomInfo.nid isEqualToString:[GlobalEntity sharedInstance].activeRoomId]) {
        cell.textLabel.textColor = [UIColor redColor];
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EDRoomInfo *roomInfo = self.listArray[indexPath.row];
    weakify_self
    [[EDTalkieManager shareInstance] online:roomInfo.nid callback:^(NSError *error) {
        strongify_self
        if (error) {
            [SVProgressHUD showSuccessWithStatus:error.description];
        }else{
            [self joinChannelWithRoomId:roomInfo.nid];
        }
    }];
    
    
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ChannelOperateViewController *mcVC = [storyboard instantiateViewControllerWithIdentifier:@"channelOperateVC"];
//    mcVC.roomId = roomInfo.nid;
//    [self.navigationController pushViewController:mcVC animated:YES];
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
