//
//  AlertView.h
//  Foovoor
//
//  Created by Hao Liu on 10/28/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UIAlertView
- (void)showInternetError;
- (void)showIncorrectCodeError;
- (void)showIncorrectPswdError;
- (void)showUnknownError;
- (void)showInvalidError;
- (void)showCustomErrorWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelText;
@end
