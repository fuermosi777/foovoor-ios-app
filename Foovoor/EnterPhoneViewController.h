//
//  EnterPhoneViewController.h
//  Foovoor
//
//  Created by Hao Liu on 10/28/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterPhoneViewController : UIViewController <UITextFieldDelegate>
{
    NSMutableData *incomingData;
}
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *phone;
@property UIActivityIndicatorView *indicatorView;
@end
