//
//  ActiveViewController.h
//  Foovoor
//
//  Created by Hao Liu on 10/28/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActiveViewController : UIViewController <UITextFieldDelegate>

{
    NSMutableData *incomingData;
}
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *code;
@property (strong) UIActivityIndicatorView *indicatorView;
@end
