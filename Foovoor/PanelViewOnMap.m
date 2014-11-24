//
//  PanelViewOnMap.m
//  Foovoor
//
//  Created by Hao Liu on 11/5/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "PanelViewOnMap.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PanelViewOnMap

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor]; // 背景色
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.layer.cornerRadius = 4.0;
        
        // shadow
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.3;
    }
    return self;
}

- (void)setImage:(NSString *)URLString {
    // 添加restaurant图片
    UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.bounds.origin.y+15, self.bounds.size.height-30, self.bounds.size.height-30)];
    
    // 取得photo地址
    NSURL *photo_URL = [[NSURL alloc] initWithString:URLString];
    
    [photo sd_setImageWithURL:photo_URL];
    
    [self addSubview:photo];
}

- (void)setTitle:(NSString *)title {
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.height, self.bounds.origin.y + 15.0, self.bounds.size.width-self.bounds.size.height, 20)];
    
    name.text = title;
    name.font = [UIFont fontWithName:@"MavenProRegular" size:14];
    
    [self addSubview:name];
}

- (void)setTitle2:(NSString *)title {
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.height, self.bounds.origin.y + 35.0, self.bounds.size.width-self.bounds.size.height, 20)];
    
    name.text = title;
    name.textColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1];
    
    name.font = [UIFont fontWithName:@"MavenProRegular" size:14];
    
    [self addSubview:name];
}

- (void)setTitle3:(NSString *)title {
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.height, self.bounds.origin.y + 55.0, self.bounds.size.width-self.bounds.size.height, 20)];
    
    name.text = title;
    
    name.font = [UIFont fontWithName:@"MavenProRegular" size:14];
    
    [self addSubview:name];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
