//
//  DateScrollViewButton.m
//  Foovoor
//
//  Created by Hao Liu on 10/23/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "DateScrollViewButton.h"

@implementation DateScrollViewButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self){
        self.isSelected = false;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontWithName:@"MavenProRegular" size:14];
    }
    return self;
}

- (void)selectButton {
    [self setTitleColor:[UIColor colorWithRed:0.93 green:0.35 blue:0.22 alpha:1] forState:UIControlStateNormal];

}

- (void)resetButton {
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
@end
