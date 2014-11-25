//
//  HomeTableViewController.m
//  Foovoor
//
//  Created by Hao Liu on 11/25/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "HomeTableViewController.h"
#import "LearnmoreViewController.h"
#import <GBVersionTracking/GBVersionTracking.h> // tracking version, lauching times
#import "GetHomeDeals.h"
#import "BusinessDetailViewController.h"
#import "PanelView.h"
#import "HeartButton.h"

@interface HomeTableViewController ()

@end

@implementation HomeTableViewController

- (void)viewDidAppear:(BOOL)animated {
    if (_appearFirstTime) {
        if (!self.checkLoginStatus || [GBVersionTracking isFirstLaunchForVersion]) {
            [self redirectToLearnmoreView];
        }
    }
    _appearFirstTime = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set first time
    _appearFirstTime = YES;
    
    self.navigationController.navigationBar.topItem.title = @"Explore";
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    self.homeArray = [userInfo valueForKey:@"homeArray"];
    
    // start
    if (!self.homeArray) {
        [self loadData];
    }
    
    [self addRefreshButton];
    
    // set table view
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.showsVerticalScrollIndicator = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - necessary objs

- (void)initActivityIndicator {
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_indicator setColor:[UIColor colorWithRed:0.93 green:0.35 blue:0.23 alpha:1]];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_indicator];
    self.navigationItem.leftBarButtonItem = item;
    _indicator.hidesWhenStopped = YES;
}

- (void)loadData {
    [_indicator startAnimating];
    
    // 获取热门餐厅from URL
    GetHomeDeals *getHomeDeals = [[GetHomeDeals alloc] init];
    NSURL *url = [NSURL URLWithString:@"https://foovoor.com/api/get_home_deals/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __unused NSURLConnection *fetchConn = [[NSURLConnection alloc] initWithRequest:request
                                                                          delegate:getHomeDeals
                                                                  startImmediately:YES];
    // 回调关键
    getHomeDeals.delegate = self;
}

- (void)loadComplete:(NSMutableArray *)array {
    NSLog(@"com");
    [_indicator stopAnimating];
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    [userInfo setObject:array forKey:@"homeArray"];
    [userInfo synchronize];
    
    self.homeArray = array;
}

- (void)reloadView {
    [self loadData];
    [self.tableView reloadData];
}

- (void)addRefreshButton {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"]
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(reloadView)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum = [_homeArray count];
    return rowNum;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:@"Cell"];
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = [_homeArray objectAtIndex:indexPath.row];
    
    PanelView *panel = [[PanelView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 3.0 / 4.0)];
    [panel setDict:dict];
    [panel showView];
    [cell addSubview:panel];
    
    // add heart
    /*
    HeartButton *heart = [[HeartButton alloc] initWithFrame:CGRectMake(panel.frame.size.width - 55.0, panel.frame.size.width * (3.0 / 4.0 + 1.0 / 6.0) + 35.0, 40.0, 25.0)
                                               restaurantID:[[dict objectForKey:@"id"] intValue]];
    [panel addSubview:heart];
    */
    
    // 设置panel点击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(redirectToBusinessDetailView:)];
    
    [panel addGestureRecognizer:tap];
    panel.tag = [[dict objectForKey:@"id"] intValue];
    [panel setUserInteractionEnabled:YES];
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    return cell;
     
}

// 每个cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowHeight = self.view.frame.size.width * 1.2;
    return rowHeight;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - action

- (BOOL)checkLoginStatus {
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    
    NSString *username = [userInfo objectForKey:@"username"];
    
    if (username) {
        return true;
    } else {
        return false;
    }
}

#pragma mark - redirect

- (void)redirectToLearnmoreView {
    LearnmoreViewController *VC = [[LearnmoreViewController alloc] init];
    [self.tabBarController presentViewController:VC animated:YES completion:^{}];
}

- (void)redirectToBusinessDetailView:(UITapGestureRecognizer *)viewSingleFingerTap {
    BusinessDetailViewController *businessDetailViewController = [[BusinessDetailViewController alloc] init];
    [businessDetailViewController setBusinessID:viewSingleFingerTap.view.tag];
    
    // find the detail info
    NSMutableDictionary *businessDetailInfo = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [self.homeArray count]; i++) {
        if ([[[self.homeArray objectAtIndex:i] objectForKey:@"id"] intValue] == viewSingleFingerTap.view.tag) {
            businessDetailInfo = [self.homeArray objectAtIndex:i];
        }
    }
    
    // pass business detail info to vc
    [businessDetailViewController setBusinessDetail:businessDetailInfo];
    [self.navigationController pushViewController:businessDetailViewController animated:YES];
}


@end
