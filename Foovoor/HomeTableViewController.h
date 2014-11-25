//
//  HomeTableViewController.h
//  Foovoor
//
//  Created by Hao Liu on 11/25/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewController : UITableViewController

@property BOOL appearFirstTime; // if the view appear for the first time
@property (strong, nonatomic) NSMutableArray *homeArray;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;

- (void)loadComplete:(NSMutableArray *)array;

@end
