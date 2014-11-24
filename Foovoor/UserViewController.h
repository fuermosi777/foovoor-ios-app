//
//  UserViewController.h
//  Foovoor
//
//  Created by Hao Liu on 10/19/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong) NSString *username;
@property (strong) NSString *password;
@property (strong) NSMutableDictionary *dict;
@property (strong) UITableView *scrollView;
@property (strong) UIActivityIndicatorView *indicator;

- (void)loadComplete:(NSMutableDictionary *)dict;
- (void)signOutUser:(id)sender;

@end
