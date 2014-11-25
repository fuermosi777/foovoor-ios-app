// panel view on the home page

#import "PanelView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PanelView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)showView {
    [self addContentView];
    [self addBigImageView];
    [self addAvatarImageView];
    [self addTitle];
    [self addSubTitle];
    [self addDiscount];
}

- (void)addContentView {
     _contentView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, self.bounds.size.width - 30, self.bounds.size.height - 30)];
    
    [self addSubview:_contentView];
}

- (void)addBigImageView {

    NSArray *photoArray = [_dict objectForKey:@"photos"];
    NSString *bigImageURLString = [NSString alloc];
    if ([photoArray count] != 0) {
        bigImageURLString = [photoArray objectAtIndex:0];
    } else {
        bigImageURLString = [_dict objectForKey:@"photo"];
    }
    
    NSURL *bigImageURL = [NSURL URLWithString:bigImageURLString];
    
    _bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.width * 3.0 / 4.0)];
    
    [_bigImageView sd_setImageWithURL:bigImageURL];
    
    _bigImageView.layer.borderWidth = 0.5f;
    _bigImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [_contentView addSubview:_bigImageView];
}

- (void)addAvatarImageView {
    NSString *imageURLString = [NSString stringWithFormat:@"%@", [_dict objectForKey: @"photo"]];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _bigImageView.frame.size.height + 15, self.bounds.size.width / 5.0, self.bounds.size.width / 5.0)];
    [_avatarImageView sd_setImageWithURL:imageURL];
    
    _avatarImageView.clipsToBounds = YES;
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImageView.layer.borderWidth = 0.5f;
    _avatarImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [_contentView addSubview:_avatarImageView];
}

- (void)addTitle {
    _title = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.size.width + 15, _bigImageView.frame.size.height + 15, self.frame.size.width - _avatarImageView.frame.size.width - 45, 20)];
    _title.text = [NSString stringWithFormat:@"%@", [_dict objectForKey:@"name"]];
    _title.font = [UIFont fontWithName:@"MavenProRegular" size:16];
    _title.textColor = [UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1];
    
    [_contentView addSubview:_title];
}

- (void)addSubTitle {
    
    _subTitle = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.size.width + 15, _bigImageView.frame.size.height + 15 + 20 + 5, self.frame.size.width - (_avatarImageView.frame.size.width + 15), 20)];
    NSString *tags = [[[_dict objectForKey:@"tag"] valueForKey:@"description"] componentsJoinedByString:@", "];
    _subTitle.text = tags;
    _subTitle.font = [UIFont fontWithName:@"MavenProRegular" size:12];
    _subTitle.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    
    [_contentView addSubview:_subTitle];
}

- (void)addDiscount {
    _discount = [[UILabel alloc] initWithFrame:CGRectMake(0, _bigImageView.frame.size.height + _avatarImageView.frame.size.height + 30, _avatarImageView.frame.size.width, 30)];
    [_discount setBackgroundColor: [UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1]];
    [_discount setText:[NSString stringWithFormat:@"%.0f%%", [(NSString *)[_dict objectForKey:@"discount"] doubleValue] * 100]];
    [_discount setTextColor:[UIColor whiteColor]];
    [_discount setFont:[UIFont fontWithName:@"MavenProRegular" size:14]];
    [_discount setTextAlignment:NSTextAlignmentCenter];
    
    [_contentView addSubview:_discount];
}

@end
