
#import "AlertView.h"
#import "PostFavorite.h"

@implementation HeartButton

- (id)initWithFrame:(CGRect)frame restaurantID:(NSInteger)restaurantID {
    self = [super initWithFrame:frame];
    if (self) {
        // set property
        _restaurantID = restaurantID;
        
        // create heart image
        _heartView = [[UIImageView alloc] initWithFrame:self.bounds];
        _heartView.image = [UIImage imageNamed:@"heart"];
        [self addSubview:_heartView];
        _isLiked = NO;
        
        if ([self checkLoginStatus]){
            // 1 start a post data
            NSString *post = [NSString stringWithFormat:@"username=%@&password=%@&restaurant_id=%ld&action=%@",_username,_password,(long)_restaurantID,@"GET"];
            [self loadData:post];
        }
        
        // action
        [self addTarget:self
                 action:@selector(changeHeart)
       forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}

- (void)changeHeart {
    if ([self checkLoginStatus]) {
        NSString *post = [NSString stringWithFormat:@"username=%@&password=%@&restaurant_id=%ld&action=%@",_username,_password,(long)_restaurantID,@"POST"];
        // sync db
        [self loadData:post];
        
    } else {
        AlertView *alertView = [[AlertView alloc] init];
        [alertView showCustomErrorWithTitle:@"Oops" message:@"You must sign in first" cancelButton:@"OK"];
    }
    
    
}

- (void)loadData:(NSString *)post {
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding
                          allowLossyConversion:YES];
    
    // 2 get data length
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    // 3 create url request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSURL *url = [NSURL URLWithString:@"https://foovoor.com/api/favorite/"];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // 4 create connection
    PostFavorite *postFavorite = [[PostFavorite alloc] init];
    __unused NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request
                                                                    delegate:postFavorite
                                                            startImmediately:YES];
    postFavorite.delegate = self;
}

- (void)loadComplete:(NSInteger)like {
    // animation
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
    [_heartView.layer addAnimation:transition forKey:nil];
    
    if (like == 1) {
        _isLiked = YES;
        _heartView.image = [UIImage imageNamed:@"heart-full"];
    } else {
        _isLiked = NO;
        _heartView.image = [UIImage imageNamed:@"heart"];
    }
}

- (void)loadFail {
    NSLog(@"f");
}

- (BOOL)checkLoginStatus {
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    
    NSString *username = [userInfo objectForKey:@"username"];
    NSString *password = [userInfo objectForKey:@"password"];
    
    if (username) {
        self.username = username;
        self.password = password;
        return true;
    } else {
        return false;
    }
}

@end
