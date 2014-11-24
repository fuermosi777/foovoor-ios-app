//
//  LoginViewController.m
//  Foovoor
//
//  Created by Hao Liu on 10/19/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#define USERNAMEFIELD 1
#define PASSWORDFIELD 2

#import "LoginViewController.h"
#import "CoolNavigationBar.h"
#import "DeviceConfirmViewController.h"
#import "AlertView.h"
#import "SignupViewController.h"
#import "InputField.h"
#import "EnterPhoneViewController.h"
#import "RetrievePasswordViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)init {
    self = [super init];
    if (self) {
        // bg color
        [self.view setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.96 alpha:1]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showView];
    // load indicator
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.center = self.view.center;
    [self.indicatorView startAnimating];
    
}

- (void)showView {
    // scroll
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)
                                                   style:UITableViewStyleGrouped];
    
    // setup padding
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 64, 0)];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // scroll bg
    self.tableView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.96 alpha:1];
    [self.view addSubview:self.tableView];
    
    [self addSigninButton];
}

// 表格section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// row num
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int numberOfRow;
    if (section == 0) {
        numberOfRow = 2;
    } else if (section == 1) {
        numberOfRow = 1;
    }
    return numberOfRow;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *myCellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:@"Cell"];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    InputField *field = [[InputField alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 30, 40)];
                    
                    field.placeholder = @"Username";
                    field.delegate = self;
                    field.tag = USERNAMEFIELD;
                    
                    [myCellView addSubview:field];
                    
                    break;
                }
                case 1:
                {
                    InputField *field = [[InputField alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 30, 40)];
                    
                    field.placeholder = @"Password";
                    field.delegate = self;
                    field.tag = PASSWORDFIELD;
                    field.autocorrectionType = UITextAutocorrectionTypeNo;
                    field.secureTextEntry = YES;
                    
                    [myCellView addSubview:field];
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    UIButton *button = [[UIButton alloc] initWithFrame:myCellView.bounds];
                    [button setTitle:@"Forget password?" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1] forState:UIControlStateNormal];
                    
                    // set font
                    button.titleLabel.font = [UIFont fontWithName:@"MavenProRegular" size:14];
                    // add action
                    [self.view addSubview:button];
                    [button addTarget:self
                               action:@selector(redirectToRetrieveView)
                     forControlEvents:UIControlEventTouchUpInside];
                    
                    [myCellView addSubview:button];
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    
    
    // cancel highlight
    myCellView.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return myCellView;
}

- (void)redirectToRetrieveView {
    RetrievePasswordViewController *VC = [[RetrievePasswordViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == PASSWORDFIELD) {
        [textField resignFirstResponder];
        [self signinButtonTapped:nil];
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// input field delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    // determine which textfield
    if (textField.tag == USERNAMEFIELD) {
        self.username = textField.text;
    } else if (textField.tag == PASSWORDFIELD) {
        self.password = textField.text;
    }
}

- (void)addSigninButton {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign in"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(signinButtonTapped:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)signinButtonTapped:(id)sender {
    // show indicator
    [self.view addSubview:self.indicatorView];
    
    [self.view endEditing:YES];
    UIDevice *device = [UIDevice currentDevice];
    NSString *currentDeviceId = [[device identifierForVendor] UUIDString];
    
    if (self.username && self.password) {
        // 1 start a post data
        NSString *post = [NSString stringWithFormat:@"username=%@&password=%@&device=%@",self.username,self.password,currentDeviceId];
        
        
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding
                              allowLossyConversion:YES];
        // 2 get data length
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        // 3 create url request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *url = [NSURL URLWithString:@"https://foovoor.com/api/auth/"];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        // 4 create connection
        __unused NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request
                                                                        delegate:self
                                                                startImmediately:YES];
    } else {
        [self.indicatorView removeFromSuperview];
        AlertView *alert = [[AlertView alloc] init];
        [alert showInvalidError];
    }
}

// data receive part
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    incomingData = nil;
    if (!incomingData) {
        incomingData = [[NSMutableData alloc] init];
    }
    
    [incomingData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.indicatorView removeFromSuperview];
    
    AlertView *alert = [[AlertView alloc] init];
    [alert showInternetError];
}

// 数据全部接受完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.indicatorView removeFromSuperview];
    
    NSError *error = nil;
    
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:incomingData
                                                                options:kNilOptions
                                                                  error:&error];
    NSInteger status = [[dict objectForKey:@"status"] integerValue];
    
    if (status == 1) { // login success
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        [userInfo setValue:self.username forKey:@"username"];
        [userInfo setValue:self.password forKey:@"password"];
        [userInfo synchronize];
        
        [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:0] animated:YES];
        
    } else if (status == -1) { // unexplained error
        AlertView *alert = [[AlertView alloc] init];
        [alert showIncorrectPswdError];
        
    } else if (status == 2) { // new device need confirmation
        DeviceConfirmViewController *deviceViewController = [[DeviceConfirmViewController alloc] init];
        
        // pass username and pswd
        deviceViewController.username = self.username;
        deviceViewController.password = self.password;
        [self.navigationController pushViewController:deviceViewController animated:YES];
        
    } else if (status == 3) { // inactive user
        EnterPhoneViewController *phoneViewController = [[EnterPhoneViewController alloc] init];
        phoneViewController.username = self.username;
        phoneViewController.password = self.password;
        
        [self.navigationController pushViewController:phoneViewController animated:YES];
    } else if (status == 0) {
        AlertView *alert = [[AlertView alloc] init];
        [alert showIncorrectPswdError];
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
