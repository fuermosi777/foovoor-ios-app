//
//  PostFavorite.h
//  Foovoor
//
//  Created by Hao Liu on 11/14/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeartButton.h"

@interface PostFavorite : NSObject
{
    NSMutableData *incomingData;
}
@property (nonatomic, assign) HeartButton *delegate; // 声明代理

@end
