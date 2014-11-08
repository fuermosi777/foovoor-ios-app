//
//  TableViewCellIconAndTextView.m
//  Foovoor
//
//  Created by Hao Liu on 11/5/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "TableViewCellIconAndTextView.h"

@implementation TableViewCellIconAndTextView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)setTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, self.frame.size.width, self.frame.size.height)];
    label.text = title;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"MavenProRegular" size:14];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self addSubview:label];
}

- (void)setIcon:(UIImage *)icon {
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 14, 14, 14)];
    
    iconView.image = icon;
    
    [self addSubview:iconView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
