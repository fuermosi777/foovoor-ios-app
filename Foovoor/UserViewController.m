//
//  UserViewController.m
//  Foovoor
//
//  Created by Hao Liu on 10/19/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "UserViewController.h"
#import "LoginViewController.h"
#import "SignupViewController.h"
#import "GetUserInfo.h"
#import "InputField.h"
#import "TableViewCellButton.h"
#import "LearnmoreViewController.h"
#import "WebViewController.h"

@interface UserViewController ()

@end

@implementation UserViewController
- (void)viewDidAppear:(BOOL)animated {
    [self reloadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set bg color
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.96 alpha:1];
    
    // set title
    self.navigationController.navigationBar.topItem.title = @"Profile";
    
    if (!self.checkLoginStatus) {
        [self showBeforeLoginView];
    } else {
        [self loadData];
    }
    
    // init indicator
    if (!_indicator) {
        [self initActivityIndicator];
    }
}

- (void)initActivityIndicator {
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_indicator setColor:[UIColor colorWithRed:0.93 green:0.35 blue:0.23 alpha:1]];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_indicator];
    self.navigationItem.leftBarButtonItem = item;
    _indicator.hidesWhenStopped = YES;
}

- (void)reloadView {
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self viewDidLoad];
}

- (void)signOutUser:(id)sender {
    // clear NSUserDefaults
    NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domainName];
    
    [self reloadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showBeforeLoginView {
    [self addSigninButton:CGRectMake(0, 80, self.view.frame.size.width, 40)];
    [self addSignupButton:CGRectMake(-1.0, 140, self.view.frame.size.width + 2.0, 40)];
    [self addLearnmoreButton:CGRectMake(-1, 200, self.view.frame.size.width + 2.0, 40)];
    [self addPrivacyAndTermsButton:CGRectMake(-1, 239, self.view.frame.size.width + 2.0, 40)];
}

- (void)showAfterLoginView {
    [self addUserInfo];
}

- (void)addUserInfo {
    // create scroll
    self.scrollView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)
                                                   style:UITableViewStyleGrouped];
    // setup padding
    [self.scrollView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    self.scrollView.dataSource = self;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.96 alpha:1];
    
    [self.view addSubview:self.scrollView];
}

#pragma mark - table

// 表格section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 ;
}

// 分段标题设置字体颜色等
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(15, 15, self.view.frame.size.width, 20);
    myLabel.font = [UIFont fontWithName:@"MavenProRegular" size:14];
    myLabel.textColor = [UIColor colorWithRed:0.43 green:0.32 blue:0.3 alpha:1];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionName;
    switch (section)
    {
        case 0:
        {
            sectionName = @"DETAIL";
            break;
        }
        case 1:
        {
            sectionName = @"ACTION";
            break;
        }
    }
    return sectionName;
}

// 每个section的row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numOfRow;
    switch (section)
    {
        case 0:
            numOfRow = 1;
            break;
        case 1:
            numOfRow = 1;
            break;
        default:
            numOfRow = 1;
            break;
    }
    return numOfRow;
}

// 每个cell内容
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *myCellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:@"Cell"];
    
    // 填写cell内容
    if (indexPath.section == 0){
        switch (indexPath.row)
        {
            case 0:
            {
                NSString *usernameString = [NSString stringWithFormat:@"Username: %@",[self.dict objectForKey:@"username"]];
                [[myCellView textLabel] setText:usernameString];
                break;
            }
            default:
            {
                break;
            }
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row)
        {
            case 0:
            {
                TableViewCellButton *button = [[TableViewCellButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0)];
                [button setTitle:@"Sign Out" forState:UIControlStateNormal];
                [button addTarget:self
                           action:@selector(signOutUser:)
                 forControlEvents:UIControlEventAllTouchEvents];
                [myCellView addSubview:button];
            }
            default:
            {
                break;
            }
        }
    }
    // 取消每个cell的选择高亮
    myCellView.textLabel.font = [UIFont fontWithName:@"MavenProRegular" size:14];
    myCellView.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return myCellView;
}

- (void)loadData {
    [_indicator startAnimating];
    
    GetUserInfo *getUserInfo = [[GetUserInfo alloc] init];
    
    // 1 start a post data
    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@",self.username,self.password];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding
                          allowLossyConversion:YES];
    // 2 get data length
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    // 3 create url request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSURL *url = [NSURL URLWithString:@"https://foovoor.com/api/get_user_info/"];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    // 4 create connection
    __unused NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request
                                                                    delegate:getUserInfo
                                                            startImmediately:YES];
    // Callback
    getUserInfo.delegate = self;
}

- (void)loadComplete:(NSMutableDictionary *)dict {
    [_indicator stopAnimating];
    
    self.dict = dict;
    [self showAfterLoginView];
}

- (void)addSigninButton:(CGRect)frame {
    UIButton *submitButton = [[UIButton alloc] initWithFrame:frame];
    [submitButton setTitle:@"Sign in" forState:UIControlStateNormal];
    submitButton.backgroundColor = [UIColor colorWithRed:0.93 green:0.35 blue:0.22 alpha:1];
    
    // set font
    submitButton.titleLabel.font = [UIFont fontWithName:@"MavenProRegular" size:14];
    
    [self.view addSubview:submitButton];
    [submitButton addTarget:self
                     action:@selector(signinButtonTapped:)
           forControlEvents:UIControlEventTouchUpInside];
}

- (void)addSignupButton:(CGRect)frame {
    UIButton *signupButton = [[UIButton alloc] initWithFrame:frame];
    [signupButton setTitle:@"Sign up" forState:UIControlStateNormal];
    signupButton.backgroundColor = [UIColor clearColor];
    signupButton.layer.borderColor = [[UIColor colorWithRed:0.93 green:0.35 blue:0.22 alpha:1] CGColor];
    signupButton.layer.borderWidth = 0.5f;
    // set text color
    [signupButton setTitleColor:[UIColor colorWithRed:0.93 green:0.35 blue:0.22 alpha:1] forState:UIControlStateNormal];
    
    // set font
    signupButton.titleLabel.font = [UIFont fontWithName:@"MavenProRegular" size:14];
    
    [self.view addSubview:signupButton];
    [signupButton addTarget:self
                     action:@selector(signupButtonTapped:)
           forControlEvents:UIControlEventTouchUpInside];
}

- (void)addLearnmoreButton:(CGRect)frame {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:@"How to use" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderColor = [[UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1] CGColor];
    button.layer.borderWidth = .5f;
    // set text color
    [button setTitleColor:[UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1] forState:UIControlStateNormal];
    
    // set font
    button.titleLabel.font = [UIFont fontWithName:@"MavenProRegular" size:14];
    
    [self.view addSubview:button];
    [button addTarget:self
               action:@selector(redirectToLearnmoreView)
     forControlEvents:UIControlEventTouchUpInside];
}

- (void)addPrivacyAndTermsButton:(CGRect)frame {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:@"Privacy & Terms" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderColor = [[UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1] CGColor];
    button.layer.borderWidth = .5f;
    // set text color
    [button setTitleColor:[UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1] forState:UIControlStateNormal];
    
    // set font
    button.titleLabel.font = [UIFont fontWithName:@"MavenProRegular" size:14];
    
    [button addTarget:self
               action:@selector(redirectToPrivacyView:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)redirectToPrivacyView:(UITapGestureRecognizer *)tag {
    WebViewController *privacyVC = [[WebViewController alloc] init];
    [privacyVC showView:[NSURL URLWithString:@"https://foovoor.com/app/privacy-terms/"]];
    [self.navigationController pushViewController:privacyVC animated:YES];
    
}

- (void)redirectToLearnmoreView {
    LearnmoreViewController *VC = [[LearnmoreViewController alloc] init];
    [self presentViewController:VC animated:YES completion:^{}];
}

- (void)signinButtonTapped:(id)sender {
    LoginViewController *signinViewController = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:signinViewController animated:YES];
}

- (void)signupButtonTapped:(id)sender {
    SignupViewController *signupViewController = [[SignupViewController alloc] init];
    [self.navigationController pushViewController:signupViewController animated:YES];
}

- (void)redirectToLoginView {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (BOOL)checkLoginStatus {
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    
    NSString *username = [userInfo objectForKey:@"username"];
    NSString *password = [userInfo objectForKey:@"password"];
    
    if (username) {
        self.username = username;
        self.password = password;
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
