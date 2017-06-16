//
//  GlobalEntity.h
//  EasyconnTalkieDemo
//
//  Created by ch on 2017/6/7.
//  Copyright © 2017年 carbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalEntity : NSObject
+ (GlobalEntity*)sharedInstance;

@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSString *openId;
@property (nonatomic,strong) NSString *activeRoomId;

@end
