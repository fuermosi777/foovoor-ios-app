//
//  LearnmoreViewController.m
//  Foovoor
//
//  Created by Hao Liu on 11/17/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "LearnmoreViewController.h"
#import <NYXImagesKit/NYXImagesKit.h>

#define PAGES 3.0

@interface LearnmoreViewController ()

@end

@implementation LearnmoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // bg
    [self.view setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.96 alpha:1]];
    
    // create scroll
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * PAGES, self.view.frame.size.height);
    [_scrollView setPagingEnabled:YES];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i < PAGES; i++) {
        [self addSingleView:i];
    }
    
    // add control
    [self addPageControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addSingleView:(CGFloat)i {
    CGFloat xOrigin = i * self.view.frame.size.width;
    UIView *singleView = [[UIView alloc] initWithFrame:CGRectMake(xOrigin, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    
    UIImageView *bannerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"learn-more-%f", i + 1]];
    
    UIImage *imageScaled = [image scaleToSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.width * 3.0 / 4.0)];
    UIImage *imageCropped = [imageScaled cropToSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.width * 3.0 / 4.0)];
    imageScaled = nil;
    image = nil;
    bannerView.image = imageCropped;
    
    bannerView.clipsToBounds = YES;
    bannerView.contentMode = UIViewContentModeScaleAspectFill;
    
   

    
    [singleView addSubview:bannerView];
    
    
    [_scrollView addSubview:singleView];
    
    // add titles
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.width + 20, self.view.frame.size.width, 30.0)];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont fontWithName:@"MavenProRegular" size:16];
    title.textColor = [UIColor colorWithRed:0.16 green:0.16 blue:0.16 alpha:1];
    
    UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.width + 40 , self.view.frame.size.width - 40.0, 100)];
    subtitle.textAlignment = NSTextAlignmentLeft;
    subtitle.numberOfLines = 0;
    subtitle.lineBreakMode = NSLineBreakByWordWrapping;
    subtitle.font = [UIFont fontWithName:@"MavenProRegular" size:14];
    subtitle.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    
    [singleView addSubview:title];
    [singleView addSubview:subtitle];
    
    switch ((int)i) {
        case 0:
        {
            title.text = @"Explore in New York City";
            subtitle.text = @"Check our website, or use our app to explore restaurants nearby. Choose the cuisine you like. Go to the restaurant and have a try.";
            break;
        }
        case 1:
        {
            title.text = @"Enjoy the meal";
            subtitle.text = @"Enjoy meals in our partner restaurants.";
            break;
        }
        case 2:
        {
            title.text = @"Save money";
            subtitle.text = @"Get a special code using your app, and show the app to your server when you are ready to check out. Enjoy an immediate discount in real time.";
            break;
        }
    }
    
}

- (void)addPageControl {
    // create page control
    UIView *pageControlView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.0, self.view.frame.size.height - 20.0, self.view.frame.size.width, 20)];
    
    self.pageControl = [[UIPageControl alloc] init];
    [self.pageControl setNumberOfPages:PAGES];
    [self.pageControl setCurrentPage:0];
    [self.pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:0.87 green:0.31 blue:0.2 alpha:1]];
    
    [pageControlView addSubview:self.pageControl];
    
    [self.view addSubview:pageControlView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // only banner scroll view can trigger
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.x > self.view.frame.size.width * 2.0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL b){
            [self dismissViewControllerAnimated:NO completion:^{}];
            self.view.alpha = 1;
        }];
    }
}

@end
