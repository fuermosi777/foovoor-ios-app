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
        awesomeView.contentMode = UIViewContentModeScaleAspectFill;
        awesomeView.clipsToBounds = YES;
        
        // 添加hot restaurant图片，开始一个新的image download manager
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        // start a new image download manager
        [manager downloadWithURL:photoURL
                         options:0
                        progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            // NSLog(@"%li",(long)receivedSize);
                        }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                           if (image) {

                               awesomeView.image = image;
                           }
                       }];
        
        awesomeView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:awesomeView];
    }
}

@end
