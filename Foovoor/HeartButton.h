//
//  HeartButton.h
//  Foovoor
//
//  Created by Hao Liu on 11/14/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeartButton : UIButton

@property (strong,nonatomic) UIImageView *heartView;
@property BOOL isLiked;
@property NSString *username;
@property NSString *password;
@property NSInteger restaurantID;

- (id)initWithFrame:(CGRect)frame restaurantID:(NSInteger)restaurantID;
- (void)loadFail;
- (void)loadComplete:(NSInteger)like;
@end
