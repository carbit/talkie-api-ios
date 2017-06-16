//
//  EDRoomInfo.h
//  EasyconnTalkie
//
//  Created by ch on 2017/6/6.
//  Copyright © 2017年 carbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EDUserInfo.h"

@protocol EDRoomInfo <NSObject>

@end

@interface EDRoomInfo : NSObject

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

@end
