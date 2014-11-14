//
//  BusinessDetailViewController.h
//  Foovoor
//
//  Created by Hao Liu on 10/10/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessBannerScrollView.h"

@interface BusinessDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property NSInteger businessID;
@property NSMutableDictionary *businessDetail;

@property NSMutableArray *dateArray;
@property (nonatomic, strong) NSMutableArray *discountArray;

@property UITableView *scrollView;
@property UIScrollView *discountScroll;
@property NSMutableArray *dateButtons;
@property BusinessBannerScrollView *bannerScroll;
@property UIPageControl *pageControl;

@end
