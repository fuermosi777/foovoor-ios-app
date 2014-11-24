//
//  LoginViewController.h
//  Foovoor
//
//  Created by Hao Liu on 10/19/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableData *incomingData;
}
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong) UITableView *tableView;

@property (strong) UIActivityIndicatorView *indicatorView;
@end
