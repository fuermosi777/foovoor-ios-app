#import "HomeViewController.h"
#import "GetHomeDeals.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BusinessDetailViewController.h"
#import "UserViewController.h"
#import "LoginViewController.h"
#import "MapViewController.h"
#import "PanelView.h"
#import "WebViewController.h"

@interface HomeViewController ()

@property UIScrollView *scroll;

@end

@implementation HomeViewController

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set bg color
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.95 blue:0.92 alpha:1];
    
    // set font
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"MavenProRegular" size:14], NSFontAttributeName, [UIColor colorWithRed:0.93 green:0.35 blue:0.22 alpha:1], NSForegroundColorAttributeName, nil];
    
    // set bar button font
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    // customize navbar title
    self.navigationController.navigationBar.topItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"foovoor"]];
    // set clickable
    UITapGestureRecognizer *titleSingleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(redirectToAboutView:)];
    [self.navigationController.navigationBar.topItem.titleView addGestureRecognizer:titleSingleFingerTap];
    [self.navigationController.navigationBar.topItem.titleView setUserInteractionEnabled:YES];
    
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
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_indicator];
    self.navigationItem.leftBarButtonItem = item;
    _indicator.hidesWhenStopped = YES;
}

- (void)redirectToAboutView:(UITapGestureRecognizer *)tap {
    WebViewController *aboutVC = [[WebViewController alloc] init];
    [aboutVC showView:[NSURL URLWithString:@"https://foovoor.com/app/about/"]];
    [self.navigationController pushViewController:aboutVC animated:YES];
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
    // create scroll
    [self createScrollView];
    
    // add refresh button
    [self addRefreshButton];
    
    CGFloat singleViewHeight = 280;
    
    // create a new scroll view
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width,[array count] * (singleViewHeight + 15) + 45);
    [self.view addSubview:self.scroll];
    

    // create subviews in the scroll view
    for (int i = 0; i < [array count]; i++) {
        // 取得每个hot餐馆信息存入dictionary
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        dictionary = [array objectAtIndex:i];
        
        PanelView *panel = [[PanelView alloc] initWithFrame:CGRectMake(5, i * (singleViewHeight + 15) + 5.0, self.view.frame.size.width - 10.0, singleViewHeight)];
        
        // start a new image download manager
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        // 取得photo地址
        NSURL *photo_URL = [[NSURL alloc] initWithString:[dictionary objectForKey:@"photo"]];
        // start a new image download manager
        [manager downloadWithURL:photo_URL
                         options:0
                        progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            // NSLog(@"%li",(long)receivedSize);
                        }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                           if (image) {
                               [panel addImage:image];
                           }
                       }
         ];
        [panel addTitle:[dictionary objectForKey:@"name"]];

        NSString *tags = [[[dictionary objectForKey:@"tag"] valueForKey:@"description"] componentsJoinedByString:@", "];
        [panel addSubtitle:[NSString stringWithFormat:@"%@",tags]];
        [panel addDiscount:[NSString stringWithFormat:@"Up to %.0f%% off", [(NSString *)[dictionary objectForKey:@"discount"] doubleValue] * 100]];
        
        
        
        [self.scroll addSubview:panel];
        
        // 设置awesome view点击
        UITapGestureRecognizer *awesomeViewSingleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                     action:@selector(showBusinessDetailView:)];
        [panel addGestureRecognizer:awesomeViewSingleFingerTap];
        panel.tag = [[dictionary objectForKey:@"id"] intValue];
        [panel setUserInteractionEnabled:YES];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
