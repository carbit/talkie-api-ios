//
//  GlobalEntity.m
//  EasyconnTalkieDemo
//
//  Created by ch on 2017/6/7.
//  Copyright © 2017年 carbit. All rights reserved.
//

#import "GlobalEntity.h"

@implementation GlobalEntity

+ (GlobalEntity *)sharedInstance
{
    static dispatch_once_t once;
    static GlobalEntity * __singleton__;
    dispatch_once(&once, ^{ __singleton__ = [[GlobalEntity alloc] init]; } );
    return __singleton__;
}

@end
