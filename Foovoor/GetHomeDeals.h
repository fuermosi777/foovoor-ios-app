//
//  GetHomeDeals.h
//  Foovoor
//
//  Created by Hao Liu on 10/8/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeTableViewController.h"

@interface GetHomeDeals : NSObject
{
    NSMutableData *incomingData;
}
@property (nonatomic, weak) HomeTableViewController *delegate; // 声明代理

@end
