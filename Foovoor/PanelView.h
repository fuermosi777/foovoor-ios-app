//
//  PanelView.h
//  Foovoor
//
//  Created by Hao Liu on 10/26/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanelView : UIView

@property (strong) UIImageView *imageView;
@property (strong) UIImageView *avatarView;
@property (strong) UIView *contentView;
@property (strong) UILabel *titleLabel;
@property (strong) UILabel *subtitleLabel;
@property (strong) UILabel *discountLabel;

- (void)addImage:(NSString *)imageString;
- (void)addAvatar:(NSString *)avatarString;
- (void)addTitle:(NSString *)text;
- (void)addSubtitle:(NSString *)text;
- (void)addDiscount:(NSString *)text;

@end
