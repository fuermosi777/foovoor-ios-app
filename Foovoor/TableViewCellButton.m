//
//  TableViewCellButton.m
//  Foovoor
//
//  Created by Hao Liu on 11/5/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "TableViewCellButton.h"

@implementation TableViewCellButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.93 green:0.35 blue:0.23 alpha:1];
        
        // set text color
        self.titleLabel.textColor = [UIColor whiteColor];
        
        // set font
        self.titleLabel.font = [UIFont fontWithName:@"MavenProRegular" size:14];
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
