//
//  InputField.m
//  Foovoor
//
//  Created by Hao Liu on 10/28/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "InputField.h"

@implementation InputField

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.borderStyle = UITextBorderStyleNone;
        self.font = [UIFont fontWithName:@"MavenProRegular" size:14];
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.keyboardType = UIKeyboardTypeDefault;
        self.returnKeyType = UIReturnKeyDone;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
