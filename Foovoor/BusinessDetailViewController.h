//
//  BusinessDetailViewController.h
//  Foovoor
//
//  Created by Hao Liu on 10/10/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessBannerScrollView.h"
#import <MapKit/MapKit.h>

@interface BusinessDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property NSInteger businessID;
@property (strong) NSMutableDictionary *businessDetail;

@property (strong) NSMutableArray *dateArray;
@property (nonatomic, strong) NSMutableArray *discountArray;

@property (strong) UITableView *scrollView;
@property (strong) UIScrollView *discountScroll;
@property (strong) NSMutableArray *dateButtons;
@property (strong) BusinessBannerScrollView *bannerScroll;
@property (strong) UIPageControl *pageControl;

@end
