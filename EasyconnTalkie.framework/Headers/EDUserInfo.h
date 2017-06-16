//
//  EDUserInfo.h
//  EasyconnTalkie
//
//  Created by ch on 2017/6/6.
//  Copyright © 2017年 carbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EDEnumerate.h"

@protocol EDUserInfo <NSObject>

@end

@interface EDUserInfo : NSObject

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

@end
