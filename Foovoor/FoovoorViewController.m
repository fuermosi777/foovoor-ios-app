//
//  FoovoorViewController.m
//  Foovoor
//
//  Created by Hao Liu on 11/4/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "FoovoorViewController.h"

@interface FoovoorViewController ()

@end

@implementation FoovoorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    // set font
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"MavenProRegular" size:14], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    // set bar button font
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    [self becomeOpaque];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)becomeTransparent {
    CATransition *transition = [CATransition animation];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFade;
    transition.duration = 0.5;
    
    [self.navigationBar.layer addAnimation:transition forKey:nil];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparent"]
                             forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setShadowImage:[UIImage new]];
}

- (void)becomeOpaque {
    CATransition *transition = [CATransition animation];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionFade;
    transition.duration = 0.5;
    
    [self.navigationBar.layer addAnimation:transition forKey:nil];
    
    [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    self.navigationBar.barTintColor = [UIColor colorWithRed:0.91 green:0.25 blue:0.15 alpha:1];
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
