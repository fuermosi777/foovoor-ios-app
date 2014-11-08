//
//  DeviceConfirmViewController.m
//  Foovoor
//
//  Created by Hao Liu on 10/28/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "DeviceConfirmViewController.h"
#import "CoolNavigationBar.h"
#import "AlertView.h"
#import "InputField.h"

@interface DeviceConfirmViewController ()

@end

@implementation DeviceConfirmViewController

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.95 blue:0.92 alpha:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addInstructionLabel];
    [self addCodeField];
    [self addSubmitButton];
    // Do any additional setup after loading the view.
    // load indicator
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.center = self.view.center;
    [self.indicatorView startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addInstructionLabel {
    UILabel *instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, self.view.frame.size.width - 30, 80)];
    instructionLabel.text = @"We have sent a 6-digit code to your phone. Please enter that code in the text field and verify this is your phone. Thank you.";
    instructionLabel.numberOfLines = 0;
    instructionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    instructionLabel.font = [UIFont fontWithName:@"MavenProRegular" size:14];
    instructionLabel.textColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1];
    
    [self.view addSubview:instructionLabel];
}

- (void)addCodeField {
    // set font
    
    InputField *codeField = [[InputField alloc] initWithFrame:CGRectMake(15, 160, self.view.frame.size.width - 30, 40)];
    
    codeField.placeholder = @"confirmation code";
    codeField.keyboardType = UIKeyboardTypeNumberPad;
    codeField.delegate = self;
    codeField.borderStyle = UITextBorderStyleRoundedRect;
    codeField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:codeField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.code = textField.text;
}

- (void)addSubmitButton {
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 220, self.view.frame.size.width - 30, 40)];
    [submitButton setTitle:@"Confirm" forState:UIControlStateNormal];
    submitButton.backgroundColor = [UIColor colorWithRed:0.93 green:0.35 blue:0.22 alpha:1];
    submitButton.layer.cornerRadius = 4.0f;
    
    // set font
    submitButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:14];
    
    [self.view addSubview:submitButton];
    [submitButton addTarget:self
                     action:@selector(submitButtonTapped:)
           forControlEvents:UIControlEventTouchUpInside];
}

- (void)submitButtonTapped:(id)sender {
    // show indicator
    [self.view addSubview:self.indicatorView];
    
    [self.view endEditing:YES];
    UIDevice *device = [UIDevice currentDevice];
    NSString *currentDeviceId = [[device identifierForVendor] UUIDString];
    
    if (self.username && self.password && self.code) {
        // 1 start a post data
        NSString *post = [NSString stringWithFormat:@"username=%@&password=%@&device=%@&code=%@",self.username,self.password,currentDeviceId,self.code];
        
        
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding
                              allowLossyConversion:YES];
        // 2 get data length
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        // 3 create url request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *url = [NSURL URLWithString:@"https://foovoor.com/api/device/"];
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
    
    NSLog(@"%ld",(long)status);
    
    if (status == 1) { // login success
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        [userInfo setValue:self.username forKey:@"username"];
        [userInfo setValue:self.password forKey:@"password"];
        [userInfo synchronize];
        
        [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:0] animated:YES];
        
    } else { // unexplained error
        AlertView *alert = [[AlertView alloc] init];
        [alert showIncorrectCodeError];
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
