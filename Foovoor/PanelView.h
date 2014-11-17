//
//  PanelView.h
//  Foovoor
//
//  Created by Hao Liu on 10/26/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanelView : UIView

@property UIImageView *imageView;
@property UIImageView *avatarView;
@property UIView *contentView;
@property UILabel *titleLabel;
@property UILabel *subtitleLabel;
@property UILabel *discountLabel;

- (void)addImage:(NSString *)imageString;
- (void)addAvatar:(NSString *)avatarString;
- (void)addTitle:(NSString *)text;
- (void)addSubtitle:(NSString *)text;
- (void)addDiscount:(NSString *)text;

@end
