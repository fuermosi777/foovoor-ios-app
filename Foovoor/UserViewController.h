//
//  UserViewController.h
//  Foovoor
//
//  Created by Hao Liu on 10/19/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property NSString *username;
@property NSString *password;
@property NSMutableDictionary *dict;
@property UITableView *scrollView;
@property UIActivityIndicatorView *indicator;

- (void)loadComplete:(NSMutableDictionary *)dict;
- (void)signOutUser:(id)sender;

@end
