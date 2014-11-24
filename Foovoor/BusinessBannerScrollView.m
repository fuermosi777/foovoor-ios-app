//
//  BusinessBannerScrollView.m
//  Foovoor
//
//  Created by Hao Liu on 11/6/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "BusinessBannerScrollView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation BusinessBannerScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 卷动开启翻页
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.alwaysBounceVertical = NO;
    }
    return self;
}

- (void)setPhotos:(NSMutableArray *)array{
    // 重新设置卷动窗口宽度
    self.contentSize = CGSizeMake(self.frame.size.width * [array count], self.frame.size.height);
    
    for (int i = 0; i < [array count]; i++) {
        NSString *photoString = [array objectAtIndex:i];
        NSURL *photoURL = [NSURL URLWithString:photoString];
        
        // 加入卷动图片
        CGFloat xOrigin = i * self.frame.size.width;
        
        UIImageView *awesomeView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0, self.frame.size.width, self.frame.size.height)];
        awesomeView.clipsToBounds = YES;
        [awesomeView sd_setImageWithURL:photoURL];
        
        awesomeView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:awesomeView];
    }
}

@end
