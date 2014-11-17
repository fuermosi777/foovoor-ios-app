//
//  SignupViewController.m
//  Foovoor
//
//  Created by Hao Liu on 10/28/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//
#define USERNAMEFIELD 1
#define EMAILFIELD 4
#define PASSWORDFIELD 2
#define PASSWORDFIELD2 3

#import "SignupViewController.h"
#import "InputField.h"
#import "AlertView.h"
#import "EnterPhoneViewController.h"
#import "WebViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (id)init {
    self = [super init];
    if (self) {
        // bg color
        self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.96 alpha:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showView];
    // Do any additional setup after loading the view.
    
    // load indicator
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.center = self.view.center;
    [self.indicatorView startAnimating];
}

- (void)showView {
    // add scroll view
    UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)
                                                   style:UITableViewStyleGrouped];
    
    // setup padding
    [tv setContentInset:UIEdgeInsetsMake(0, 0, 64, 0)];
    
    tv.dataSource = self;
    tv.delegate = self;
    
    // scroll bg
    tv.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.96 alpha:1];
    
    [self.view addSubview:tv];
    
    [self addSignupButton];
    
    // add privacy label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 240, self.view.frame.size.width - 30, 100)];
    label.text = @"By signing up an account or opting into communications, you agree to the Foovoor Privacy and Terms";
    label.font = [UIFont fontWithName:@"MavenProRegular" size:14];
    label.textColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1];
    label.numberOfLines = 0;
    [label sizeToFit];
    [tv addSubview:label];
    
    // label click
    UITapGestureRecognizer *labelSingleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(redirectToPrivacyView:)];
    [label addGestureRecognizer:labelSingleFingerTap];
    [label setUserInteractionEnabled:YES];
}

- (void)redirectToPrivacyView:(UITapGestureRecognizer *)tag {
    WebViewController *privacyVC = [[WebViewController alloc] init];
    [privacyVC showView:[NSURL URLWithString:@"https://foovoor.com/app/privacy-terms/"]];
    [self.navigationController pushViewController:privacyVC animated:YES];

}

// 表格section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// row num
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *myCellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:@"Cell"];
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
        case 2:
        {
            InputField *field = [[InputField alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 30, 40)];
            
            field.placeholder = @"Confirm password";
            field.delegate = self;
            field.tag = PASSWORDFIELD2;
            field.autocorrectionType = UITextAutocorrectionTypeNo;
            field.secureTextEntry = YES;
            
            [myCellView addSubview:field];
            break;
        }
        case 3:
        {
            InputField *field = [[InputField alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 30, 40)];
            
            field.placeholder = @"Email";
            field.delegate = self;
            field.tag = EMAILFIELD;
            field.returnKeyType = UIReturnKeyGo;
            field.keyboardType = UIKeyboardTypeEmailAddress;
            
            [myCellView addSubview:field];
            break;
        }
        default:
            break;
    }
    
    // cancel highlight
    myCellView.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return myCellView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == EMAILFIELD) {
        [textField resignFirstResponder];
        [self signupButtonTapped:nil];
        return YES;
    }
    return NO;
}

- (void)addSignupButton {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign up"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(signupButtonTapped:)];
    self.navigationItem.rightBarButtonItem = rightButton;
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
    } else if (textField.tag == PASSWORDFIELD2) {
        self.password2 = textField.text;
    } else if (textField.tag == EMAILFIELD) {
        self.email = textField.text;
    }
}

- (void)signupButtonTapped:(id)sender {
    // show indicator
    [self.view addSubview:self.indicatorView];
    
    [self.view endEditing:YES];
    
    if (self.username && self.password && self.email && self.password2) {
        if (self.password != self.password2){
            
        }
        // 1 start a post data
        NSString *post = [NSString stringWithFormat:@"username=%@&password=%@&email=%@&password2=%@",self.username,self.password,self.email,self.password2];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding
                              allowLossyConversion:YES];
        // 2 get data length
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        // 3 create url request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *url = [NSURL URLWithString:@"https://foovoor.com/api/user/"];
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
    NSString *errorMsg = [dict objectForKey:@"error"];
    
    NSLog(@"%@",dict);
    
    if (status == 1) { // login success
        EnterPhoneViewController *phoneViewController = [[EnterPhoneViewController alloc] init];
        phoneViewController.username = self.username;
        phoneViewController.password = self.password;
        
        [self.navigationController pushViewController:phoneViewController animated:YES];
        
    } else {
        AlertView *alert = [[AlertView alloc] init];
        [alert showCustomErrorWithTitle:@"Oops!"
                                message:errorMsg
                           cancelButton:@"OK"];
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
