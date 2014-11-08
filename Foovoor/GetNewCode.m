//
//  GetNewCode.m
//  Foovoor
//
//  Created by Hao Liu on 10/19/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "GetNewCode.h"
#import "AlertView.h"

@implementation GetNewCode

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!incomingData) {
        incomingData = [[NSMutableData alloc] init];
    }
    
    [incomingData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                    message:@"Check your internet connection..."
                                                   delegate:nil
                                          cancelButtonTitle:@"Retry"
                                          otherButtonTitles:nil];
    [alert show];
}

// 数据全部接受完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:incomingData
                                                            options:kNilOptions
                                                              error:&error];
    NSInteger status = [[dict objectForKey:@"status"] integerValue];
    NSString *errorMsg = [dict objectForKey:@"error"];
    NSString *code = [dict objectForKey:@"code"];
    
    if (status == 1) {
        [_delegate loadComplete:code];
    } else {
        AlertView *alert = [[AlertView alloc] init];
        [alert showCustomErrorWithTitle:@"Oops!" message:errorMsg cancelButton:@"OK"];
    }
}

@end
