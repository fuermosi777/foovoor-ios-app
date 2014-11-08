//
//  GetHomeDeals.m
//  Foovoor
//
//  Created by Hao Liu on 10/8/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "GetHomeDeals.h"
#import "HomeViewController.h"
#import "AlertView.h"

@implementation GetHomeDeals

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
    NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:incomingData
                                                              options:kNilOptions
                                                                error:&error];
    [_delegate loadComplete:array];
    
    

}

@end
