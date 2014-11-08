//
//  CodeViewController.m
//  Foovoor
//
//  Created by Hao Liu on 10/11/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "CodeViewController.h"
#import "GetNewCode.h"
#import "BigCodeLabel.h"
#import "CoolNavigationBar.h"

@interface CodeViewController ()

@property BigCodeLabel *codeLabel;

@end

@implementation CodeViewController

- (void)viewDidAppear:(BOOL)animated {
    [self reloadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set bg color
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.95 blue:0.92 alpha:1];
    
    // check login
    if (!self.checkLoginStatus) {
        [self.tabBarController setSelectedIndex:2];
    } else {
        [self showView];
    }
    
    
}

- (void)showView {
    [self addRequestButton];
    [self addInstructionLabel];
}

- (void)reloadView {
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self viewDidLoad];
}

- (void)addInstructionLabel {
    UILabel *instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 250, self.view.frame.size.width - 30, 80)];
    instructionLabel.text = @"Click button to get a new code. Please show the 6-digit code to your waiter or waitress when checking out. Enjoy.";
    instructionLabel.numberOfLines = 0;
    instructionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    instructionLabel.font = [UIFont fontWithName:@"MavenProRegular" size:14];
    instructionLabel.textColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1];
    
    [self.view addSubview:instructionLabel];
}

- (void)loadComplete:(NSString *)code {
    [self removeCode];
    [self showCode:code];
    }

- (void)loadCode {
    // read username and pswd
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    
    NSString *username = [userInfo objectForKey:@"username"];
    NSString *password = [userInfo objectForKey:@"password"];
    
    // get a new code
    GetNewCode *getNewCode = [[GetNewCode alloc] init];
    // 1 start a post data
    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@",username,password];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding
                          allowLossyConversion:YES];
    // 2 get data length
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    // 3 create url request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSURL *url = [NSURL URLWithString:@"https://foovoor.com/api/new_code/"];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    // 4 create connection
    __unused NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request
                                                           delegate:getNewCode
                                                   startImmediately:YES];

    // 回调关键
    getNewCode.delegate = self;
}

- (void)removeCode {
    [self.codeLabel removeFromSuperview];
}

- (void)showCode:(NSString *)code {
    self.codeLabel = [[BigCodeLabel alloc] initWithCode:code];
    [self.view addSubview:self.codeLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addRequestButton {
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 100, self.view.frame.size.width - 30, 40)];
    [submitButton setTitle:@"New code" forState:UIControlStateNormal];
    submitButton.backgroundColor = [UIColor colorWithRed:0.93 green:0.35 blue:0.22 alpha:1];
    submitButton.layer.cornerRadius = 4.0f;
    
    // set font
    submitButton.titleLabel.font = [UIFont fontWithName:@"MavenProRegular" size:14];
    
    [self.view addSubview:submitButton];
    [submitButton addTarget:self
                     action:@selector(loadCode)
           forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)checkLoginStatus {
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    
    NSString *username = [userInfo objectForKey:@"username"];
    
    if (username) {
        return true;
    } else {
        return false;
    }
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
