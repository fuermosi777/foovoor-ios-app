//
//  GetUserInfo.m
//  Foovoor
//
//  Created by Hao Liu on 11/5/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "GetUserInfo.h"
#import "AlertView.h"

@implementation GetUserInfo

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!incomingData) {
        incomingData = [[NSMutableData alloc] init];
    }
    
    [incomingData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    AlertView *alertView = [[AlertView alloc] init];
    [alertView showInternetError];
}

// 数据全部接受完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    
    // 先输出array，然后第0位的才是dict
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:incomingData
                                                                options:kNilOptions
                                                                  error:&error];
    
    NSInteger status = [[dict objectForKey:@"status"] integerValue];
    NSString *errorMsg = [dict objectForKey:@"error"];
    NSMutableDictionary *userInfoDict = [dict objectForKey:@"user_info"];
    
    if (status == 1) {
        [_delegate loadComplete:userInfoDict];
    } else {
        [_delegate signOutUser:nil];
        AlertView *alert = [[AlertView alloc] init];
        [alert showCustomErrorWithTitle:@"Oops!" message:errorMsg cancelButton:@"OK"];
    }
}


@end
