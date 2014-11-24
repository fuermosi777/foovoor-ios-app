// panel view on the home page

#import "PanelView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PanelView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self showBigView:frame];
        
        CATransition *transition = [CATransition animation];
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        transition.type = kCATransitionFade;
        transition.duration = 0.5;
    }
    return self;
}

- (void)showBigView:(CGRect)frame {
    CGFloat avatarHeight = self.bounds.size.width * 1.0 / 6.0;
    CGFloat avatarWidth = avatarHeight;
    CGFloat imageHeight = self.bounds.size.width * 3.0/ 4.0;
    CGFloat imageWidth = self.bounds.size.width;
    

    //
    self.contentView = [[UIView alloc] initWithFrame:self.bounds];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    // image view
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,imageWidth,imageHeight)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    
    // avatar view
    self.avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0,self.imageView.frame.size.height + 15.0, avatarWidth, avatarHeight)];
    self.avatarView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarView.clipsToBounds = YES;
    
    // title label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarWidth + 15.0, self.imageView.frame.size.height + 5.0, self.imageView.frame.size.width - avatarWidth - 45.0, 40)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor colorWithRed:0.09 green:0.09 blue:0.09 alpha:1];
    [self.titleLabel setFont:[UIFont fontWithName:@"MavenProRegular" size:18]];
    
    // subtitle label
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarWidth + 15.0, self.imageView.frame.size.height + 5.0 + 25.0, self.imageView.frame.size.width - 30.0, 40)];
    self.subtitleLabel.textColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1];
    [self.subtitleLabel setFont:[UIFont fontWithName:@"MavenProRegular" size:14]];
    
    // discount label
    self.discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageHeight + avatarHeight + 15.0 + 15.0, avatarWidth, 25)];
    
    // divider
    UILabel *divider = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width / 5.0 * 2.0, self.bounds.size.height + 40.0, self.bounds.size.width / 5.0, 2)];
    divider.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1];
    [self.contentView addSubview:divider];
   

    self.discountLabel.textColor = [UIColor whiteColor];
    [self.discountLabel setTextAlignment:NSTextAlignmentCenter];
    [self.discountLabel.layer setCornerRadius:0.0];
    self.discountLabel.backgroundColor = [UIColor colorWithRed:0.93 green:0.35 blue:0.23 alpha:1];
    self.discountLabel.clipsToBounds = YES;
    [self.discountLabel setFont:[UIFont fontWithName:@"MavenProRegular" size:14]];
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.discountLabel];
}

- (void)addImage:(NSString *)imageString {
    if (self) {
        NSURL *photo_URL = [[NSURL alloc] initWithString:imageString];
        
        [self.imageView sd_setImageWithURL:photo_URL];
    }
}

- (void)addAvatar:(NSString *)avatarString {
    if (self) {
        NSURL *photo_URL = [[NSURL alloc] initWithString:avatarString];
        [self.avatarView sd_setImageWithURL:photo_URL];
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
