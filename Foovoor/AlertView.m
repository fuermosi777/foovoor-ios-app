//
//  AlertView.m
//  Foovoor
//
//  Created by Hao Liu on 10/28/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

- (void)showInternetError {
    self.title = @"Oops!";
    self.message = @"Please check your Internet connection";
    self.cancelButtonIndex = [self addButtonWithTitle:@"OK"];
    [self show];
}

- (void)showIncorrectPswdError {
    self.title = @"Oops!";
    self.message = @"The username and password don't match";
    self.cancelButtonIndex = [self addButtonWithTitle:@"OK"];
    [self show];
}

- (void)showIncorrectCodeError {
    self.title = @"Oops!";
    self.message = @"The code is incorrect";
    self.cancelButtonIndex = [self addButtonWithTitle:@"OK"];
    [self show];
}

- (void)showUnknownError {
    self.title = @"Oops!";
    self.message = @"Unknown error";
    self.cancelButtonIndex = [self addButtonWithTitle:@"OK"];
    [self show];
}

- (void)showInvalidError {
    self.title = @"Oops!";
    self.message = @"The input is invalid";
    self.cancelButtonIndex = [self addButtonWithTitle:@"OK"];
    [self show];
}

- (void)showCustomErrorWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelText {
    self.title = title;
    self.message = message;
    self.cancelButtonIndex = [self addButtonWithTitle:cancelText];
    [self show];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
