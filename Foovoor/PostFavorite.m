//
//  PostFavorite.m
//  Foovoor
//
//  Created by Hao Liu on 11/14/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "PostFavorite.h"
#import "HeartButton.h"

@implementation PostFavorite
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!incomingData) {
        incomingData = [[NSMutableData alloc] init];
    }
    
    [incomingData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [_delegate loadFail];
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
    NSInteger like = [[dict objectForKey:@"like"] integerValue];
    NSLog(@"%li",(long)like);
    if (status == 1) {
        [_delegate loadComplete:like];
    } else {
        [_delegate loadFail];
    }
}
@end
