//
//  HomeViewController.h
//  Foovoor
//
//  Created by Hao Liu on 10/8/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *homeArray;

@property UIActivityIndicatorView *indicator;


- (void)loadData;
- (void)loadComplete:(NSMutableArray *)array;
- (void)showView:(NSMutableArray *)array;

@end
