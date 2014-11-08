//
//  GetNewCode.h
//  Foovoor
//
//  Created by Hao Liu on 10/19/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CodeViewController.h"

@interface GetNewCode : NSObject
{
    NSMutableData *incomingData;
}
@property (nonatomic, assign) CodeViewController *delegate;

@end
