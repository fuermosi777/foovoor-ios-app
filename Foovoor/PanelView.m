// panel view on the home page

#import "PanelView.h"

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
    //
    self.contentView = [[UIView alloc] initWithFrame:self.bounds];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    // image view
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    
    // title label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.imageView.frame.size.height * 3.5 / 5.0, self.imageView.frame.size.width - 30.0, 40)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.titleLabel setFont:[UIFont fontWithName:@"MavenProRegular" size:20]];
    
    // subtitle label
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.imageView.frame.size.height * 3.5 / 5.0 + 25.0, self.imageView.frame.size.width - 30.0, 40)];
    self.subtitleLabel.textColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1];
    [self.subtitleLabel setFont:[UIFont fontWithName:@"MavenProRegular" size:14]];
    
    // discount label
    self.discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 40, 20)];

    self.discountLabel.textColor = [UIColor whiteColor];
    [self.discountLabel setTextAlignment:NSTextAlignmentCenter];
    [self.discountLabel.layer setCornerRadius:4.0];
    self.discountLabel.clipsToBounds = YES;
    [self.discountLabel setFont:[UIFont fontWithName:@"MavenProRegular" size:14]];
    
    // 加入渐变layer
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;

    // 渐变颜色
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6] CGColor], nil];
    [self.imageView.layer addSublayer:gradient];
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.imageView];
    [self.imageView addSubview:self.titleLabel];
    [self.imageView addSubview:self.subtitleLabel];
    [self.imageView addSubview:self.discountLabel];
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
        float discount = [text floatValue];
        if (discount > 5 && discount <= 10) {
            self.discountLabel.backgroundColor = [UIColor colorWithRed:0.39 green:0.62 blue:0.37 alpha:0.9];
        } else if (discount > 10 && discount <= 15){
            self.discountLabel.backgroundColor = [UIColor colorWithRed:0.71 green:0.16 blue:0.31 alpha:0.9];
        } else {
            self.discountLabel.backgroundColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.46 alpha:0.9];
        }
        self.discountLabel.text = text;
    }
}

@end
