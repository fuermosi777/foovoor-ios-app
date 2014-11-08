//
//  GetUserInfo.h
//  Foovoor
//
//  Created by Hao Liu on 11/5/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserViewController.h"

@interface GetUserInfo : NSObject
{
    NSMutableData *incomingData;
}
@property (nonatomic, assign) UserViewController *delegate; // 声明代理

@end
