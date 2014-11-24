#import "HomeViewController.h"
#import "GetHomeDeals.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BusinessDetailViewController.h"
#import "UserViewController.h"
#import "LoginViewController.h"
#import "MapViewController.h"
#import "PanelView.h"
#import "WebViewController.h"
#import "AlertView.h"
#import "HeartButton.h"
#import <GBVersionTracking/GBVersionTracking.h> // tracking version, lauching times
#import "LearnmoreViewController.h"

@interface HomeViewController ()

@property UIScrollView *scroll;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {

}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    if (!self.checkLoginStatus || [GBVersionTracking isFirstLaunchForVersion]) {
        [self redirectToLearnmoreView];
    }
    
    // set bg color
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.96 alpha:1];
    
    // customize navbar title
    self.navigationController.navigationBar.topItem.title = @"Explore";
    
    // Do any additional setup after loading the view
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    self.homeArray = [userInfo valueForKey:@"homeArray"];
    
    // customize view
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // start
    if (self.homeArray) {
        [self showView:self.homeArray];
    } else {
        [self loadData];
    }
    
    // init indicator
    if (!_indicator) {
        [self initActivityIndicator];
    }
}

- (void)initActivityIndicator {
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_indicator setColor:[UIColor colorWithRed:0.93 green:0.35 blue:0.23 alpha:1]];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_indicator];
    self.navigationItem.leftBarButtonItem = item;
    _indicator.hidesWhenStopped = YES;
}

- (void)redirectToAboutView:(UITapGestureRecognizer *)tap {
    WebViewController *aboutVC = [[WebViewController alloc] init];
    [aboutVC showView:[NSURL URLWithString:@"https://foovoor.com/app/about/"]];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (void)redirectToLearnmoreView {
    LearnmoreViewController *VC = [[LearnmoreViewController alloc] init];
    [self presentViewController:VC animated:YES completion:^{}];
}

- (void)reloadView {
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // remove from local
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"homeArray"];
    [defaults synchronize];
    
    [self viewDidLoad];
}

- (void)addRefreshButton {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"]
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(reloadView)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)createScrollView {
    
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scroll setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    self.scroll.showsVerticalScrollIndicator = NO;
}

- (void)loadComplete:(NSMutableArray *)array {
    [_indicator stopAnimating];
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    [userInfo setObject:array forKey:@"homeArray"];
    [userInfo synchronize];
    
    self.homeArray = array;
    
    [self showView:self.homeArray];
}

- (void)loadData {
    [_indicator startAnimating];
    
    // 获取热门餐厅from URL
    GetHomeDeals *getHomeDeals = [[GetHomeDeals alloc] init];
    NSURL *url = [NSURL URLWithString:@"https://foovoor.com/api/get_home_deals/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __unused NSURLConnection *fetchConn = [[NSURLConnection alloc] initWithRequest:request
                                                                          delegate:getHomeDeals
                                                                  startImmediately:YES];
    // 回调关键
    getHomeDeals.delegate = self;
}

- (void)showView:(NSMutableArray *)array {
    // create vars
    CGFloat bigPanelHeight = self.view.frame.size.width;
    CGFloat bigPanelWidth = self.view.frame.size.width;
    
    // create scroll
    [self createScrollView];
    
    // add refresh button
    [self addRefreshButton];
    
    // create a new scroll view
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width, (bigPanelHeight + 60.0) * [array count]);
    [self.view addSubview:self.scroll];
    
    
    
    // create subviews in the scroll view
    for (int i = 0; i < [array count]; i++) {
        // 取得每个hot餐馆信息存入dictionary
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        dictionary = [array objectAtIndex:i];
        
        NSMutableArray *photoArray = [dictionary objectForKey:@"photos"];

        PanelView *panel = [[PanelView alloc] initWithFrame:CGRectMake(10, i * (bigPanelHeight + 60.0), bigPanelWidth - 20.0, bigPanelHeight)];
        
        if ([photoArray count] != 0) {
            NSString *photoString = [photoArray objectAtIndex:0];
            [panel addImage:photoString];
        } else {
            NSString *photoString = [dictionary objectForKey:@"photo"];
            [panel addImage:photoString];
        }
        
        // add avatar
        NSString *avatarString = [dictionary objectForKey:@"photo"];
        [panel addAvatar:avatarString];
        
        
        // add title
        [panel addTitle:[dictionary objectForKey:@"name"]];

        NSString *tags = [[[dictionary objectForKey:@"tag"] valueForKey:@"description"] componentsJoinedByString:@", "];
        [panel addSubtitle:[NSString stringWithFormat:@"%@",tags]];
        [panel addDiscount:[NSString stringWithFormat:@"%.0f%%", [(NSString *)[dictionary objectForKey:@"discount"] doubleValue] * 100]];
        
        // heart button
        HeartButton *heart = [[HeartButton alloc] initWithFrame:CGRectMake(panel.frame.size.width - 40.0, panel.frame.size.width * (3.0 / 4.0 + 1.0 / 6.0) + 30.0, 40.0, 25.0)
                                                   restaurantID:[[dictionary objectForKey:@"id"] intValue]];
        [panel addSubview:heart];
        
        
        
        [self.scroll addSubview:panel];
        
        // 设置awesome view点击
        UITapGestureRecognizer *awesomeViewSingleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                     action:@selector(showBusinessDetailView:)];
        awesomeViewSingleFingerTap.numberOfTapsRequired = 1;
        
        [panel addGestureRecognizer:awesomeViewSingleFingerTap];
        panel.tag = [[dictionary objectForKey:@"id"] intValue];
        [panel setUserInteractionEnabled:YES];
        
        
        // set awesome view double tap
        UITapGestureRecognizer *awesomeViewDoubleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:heart
                                                                                                     action:@selector(changeHeart)];
        awesomeViewDoubleFingerTap.numberOfTapsRequired = 2;
        
        [panel addGestureRecognizer:awesomeViewDoubleFingerTap];
        
        [awesomeViewSingleFingerTap requireGestureRecognizerToFail:awesomeViewDoubleFingerTap];
    }
}

- (void)showBusinessDetailView:(UITapGestureRecognizer *)viewSingleFingerTap {
    BusinessDetailViewController *businessDetailViewController = [[BusinessDetailViewController alloc] init];
    [businessDetailViewController setBusinessID:viewSingleFingerTap.view.tag];
    
    // find the detail info
    NSMutableDictionary *businessDetailInfo = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [self.homeArray count]; i++) {
        if ([[[self.homeArray objectAtIndex:i] objectForKey:@"id"] intValue] == viewSingleFingerTap.view.tag) {
            businessDetailInfo = [self.homeArray objectAtIndex:i];
        }
    }
    
    // pass business detail info to vc
    [businessDetailViewController setBusinessDetail:businessDetailInfo];
    [self.navigationController pushViewController:businessDetailViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)checkLoginStatus {
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    
    NSString *username = [userInfo objectForKey:@"username"];
    
    if (username) {
        return true;
    } else {
        return false;
    }
}

@end
