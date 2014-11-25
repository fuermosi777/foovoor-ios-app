//
//  PanelView.h
//  Foovoor
//
//  Created by Hao Liu on 10/26/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanelView : UIView

@property (strong, nonatomic) NSMutableDictionary *dict;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *bigImageView;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *subTitle;
@property (strong, nonatomic) UILabel *discount;

- (void)showView;

@end
