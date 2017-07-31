//
//  GlobalEntity.h
//  EasyconnTalkieDemo
//
//  Created by ch on 2017/6/7.
//  Copyright © 2017年 carbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalEntity : NSObject

typedef void (^EDCompleteBlock) (id pra1, id pra2, id pra3);
+ (GlobalEntity*)sharedInstance;

@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSString *openId;
@property (nonatomic,strong) NSString *activeRoomId;

@end
