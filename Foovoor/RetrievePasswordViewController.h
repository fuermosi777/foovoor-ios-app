//
//  RetrievePasswordViewController.h
//  Foovoor
//
//  Created by Hao Liu on 11/19/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RetrievePasswordViewController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableData *incomingData;
}
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *email;
@property (strong) UITableView *tableView;

@property (strong) UIActivityIndicatorView *indicatorView;
@end
