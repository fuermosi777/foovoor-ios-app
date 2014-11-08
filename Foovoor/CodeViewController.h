//
//  CodeViewController.h
//  Foovoor
//
//  Created by Hao Liu on 10/11/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeViewController : UIViewController

@property NSString *code;

- (void)loadCode;
- (void)removeCode;
- (void)showCode:(NSString *)code;
- (void)loadComplete:(NSString *)code;
@end
