//
//  PanelView.m
//  Foovoor
//
//  Created by Hao Liu on 10/26/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "PanelView.h"

@implementation PanelView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.contentView = [[UIView alloc] initWithFrame:self.bounds];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // image view
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height * 3.0 / 4.0)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        
        // title label
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.imageView.frame.size.height + 5.0, frame.size.width - 30.0, 40)];
        [self.titleLabel setFont:[UIFont fontWithName:@"MavenProRegular" size:16]];
        
        // subtitle label
        self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.imageView.frame.size.height + 25.0, frame.size.width - 30.0, 40)];
        self.subtitleLabel.textColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1];
        [self.subtitleLabel setFont:[UIFont fontWithName:@"MavenProRegular" size:14]];
        
        // discount label
        self.discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.imageView.frame.size.height + 25.0, frame.size.width - 30.0, 40)];
        self.discountLabel.textColor = [UIColor colorWithRed:0.93 green:0.35 blue:0.22 alpha:1];
        [self.discountLabel setTextAlignment:NSTextAlignmentRight];
        [self.discountLabel setFont:[UIFont fontWithName:@"MavenProRegular" size:14]];
        
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subtitleLabel];
        [self.contentView addSubview:self.discountLabel];
        
        // radius
        self.contentView.layer.cornerRadius = 4.0;
        self.contentView.layer.masksToBounds = YES;
        
        // shadow
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.3;
    }
    return self;
}

- (void)addImage:(UIImage *)image {
    if (self) {
        self.imageView.image = image;
    }
}

- (void)addTitle:(NSString *)text {
    if (self) {
        self.titleLabel.text = text;
    }
}

- (void)addSubtitle:(NSString *)text {
    if (self) {
        self.subtitleLabel.text = text;
    }
}

- (void)addDiscount:(NSString *)text {
    if (self) {
        self.discountLabel.text = text;
    }
}

@end
