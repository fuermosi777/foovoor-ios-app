//
//  FoovoorTabViewController.m
//  Foovoor
//
//  Created by Hao Liu on 11/4/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "FoovoorTabViewController.h"

@interface FoovoorTabViewController ()

@end

@implementation FoovoorTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor colorWithRed:0.93 green:0.35 blue:0.23 alpha:1];
    self.tabBar.barTintColor = [UIColor blackColor];

    self.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController{

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
