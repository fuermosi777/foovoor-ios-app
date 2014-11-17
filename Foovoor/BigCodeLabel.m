//
//  BigCodeLabel.m
//  Foovoor
//
//  Created by Hao Liu on 10/19/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "BigCodeLabel.h"

@implementation BigCodeLabel

- (id)initWithFrame:(CGRect)frame code:(NSString *)code {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setText:code];
        [self setFont:[UIFont fontWithName:@"MavenProRegular" size:60]];
        [self setTextColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]];
        [self setTextAlignment:NSTextAlignmentCenter];
    }
    return self;
}

@end
