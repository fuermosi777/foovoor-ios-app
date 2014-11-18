//
//  BusinessDetailViewController.m
//  Foovoor
//
//  Created by Hao Liu on 10/10/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "BusinessDetailViewController.h"
#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DateScrollViewButton.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TableViewCellIconAndTextView.h"
#import <MapKit/MapKit.h>
#import "MapSingleViewController.h"
#import "BusinessBannerScrollView.h"
#import "FoovoorViewController.h"

#define BANNER 0
#define NOTE 1
#define DETAILS 2
#define DISCOUNT 3
#define MAP 4
#define DESCRIPTION 5
#define SECTION_NUM 6


@interface BusinessDetailViewController ()

@end

@implementation BusinessDetailViewController

- (void)viewWillDisappear:(BOOL)animated {

}

- (void)viewWillAppear:(BOOL)animated {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set bg color
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.96 alpha:1];
    
    // set title
    self.navigationItem.title = (NSString *)[self.businessDetail objectForKey:@"name"];
    
    // create scroll
    [self createScrollView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    // initialize date buttons array
    self.dateButtons = [NSMutableArray new];
}

- (void)createScrollView {
    // create scroll
    self.scrollView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 60)
                                                   style:UITableViewStyleGrouped];
    
    self.scrollView.dataSource = self;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView setSeparatorColor:[UIColor clearColor]];
    
    // bg
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.96 alpha:1];
    
    [self.view addSubview:self.scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// table

// 表格section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SECTION_NUM ;
}

// 分段标题设置字体颜色等
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(15, 15, self.view.frame.size.width, 20);
    myLabel.font = [UIFont fontWithName:@"MavenProRegular" size:14];
    myLabel.textColor = [UIColor colorWithRed:0.43 green:0.32 blue:0.3 alpha:1];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}

// section title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionName;
    switch (section)
    {
        case BANNER:
            break;
        case DETAILS:
            sectionName = @"DETAILS";
            break;
        case DISCOUNT:
            sectionName = @"DISCOUNT";
            break;
        case MAP:
            sectionName = @"MAP";
            break;
        case DESCRIPTION:
            sectionName = @"DISCRIPTION";
            break;
        case NOTE:
            sectionName = @"NOTE";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

// space between sections
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height;
    switch (section)
    {
        case BANNER:
            height = 64.0;
            break;
        default:
            height = 40.0;
            break;
    }
    return height;
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height;
    switch (section)
    {
        default:
            height = 4.0;
            break;
    }
    return height;
}


// 每个section的row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numOfRow;
    switch (section)
    {
        case BANNER:
            numOfRow = 1;
            break;
        case DETAILS:
            numOfRow = 4;
            break;
        case DISCOUNT:
            numOfRow = 2;
            break;
        case MAP:
            numOfRow = 1;
            break;
        case DESCRIPTION:
            numOfRow = 1;
            break;
        case NOTE:
            numOfRow = 1;
            break;
        default:
            numOfRow = 1;
            break;
    }
    return numOfRow;
}
// 每个cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowHeight;
    
    switch (indexPath.section)
    {
        case BANNER:
            rowHeight = self.view.frame.size.width * 3.0 / 4.0;
            break;
        case MAP:
            rowHeight = 100;
            break;
        case NOTE:
        {
            // get height
            CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width, FLT_MAX);
            CGSize expectedLabelSize = [[self.businessDetail objectForKey:@"note"] sizeWithFont:[UIFont fontWithName:@"MavenProRegular" size:14]
                                                                              constrainedToSize:maximumLabelSize
                                                                                  lineBreakMode:NSLineBreakByWordWrapping];
            
            //adjust the label the the new height.
            rowHeight = expectedLabelSize.height + 45;
            break;
        }
        case DESCRIPTION:
        {
            // get height
            CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width, FLT_MAX);
            CGSize expectedLabelSize = [[self.businessDetail objectForKey:@"description"] sizeWithFont:[UIFont fontWithName:@"MavenProRegular" size:14]
                                                                              constrainedToSize:maximumLabelSize
                                                                                  lineBreakMode:NSLineBreakByWordWrapping];
            
            //adjust the label the the new height.
            rowHeight = expectedLabelSize.height * 1.8;
    
            break;
        }
        default:
            rowHeight = 40;
            break;
    }
    return rowHeight;
}

// 每个cell内容
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *myCellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:@"Cell"];
    
    // 填写cell内容
    if (indexPath.section == BANNER) {
        
        UIView *bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 3.0 / 4.0)];
        
        self.bannerScroll = [[BusinessBannerScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 3.0 / 4.0)];
        self.bannerScroll.backgroundColor = [UIColor colorWithRed:0.97 green:0.95 blue:0.92 alpha:1];
        self.bannerScroll.delegate = self; // set delegate for scroll control
        
        NSMutableArray *photoArray = [[self.businessDetail objectForKey:@"photos"] mutableCopy];
        
        [photoArray insertObject:[self.businessDetail objectForKey:@"photo"] atIndex:0];
        
        [self.bannerScroll setPhotos:photoArray];
        
        [myCellView addSubview:bannerView];
        [bannerView addSubview:self.bannerScroll];
        
        
        // create page control
        UIView *pageControlView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.0, self.view.frame.size.width * 3.0 / 4.0 + bannerView.bounds.origin.y + 10, self.view.frame.size.width, 20)];
        
        self.pageControl = [[UIPageControl alloc] init];
        [self.pageControl setNumberOfPages:[photoArray count]];
        [self.pageControl setCurrentPage:0];
        [self.pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [self.pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:0.87 green:0.31 blue:0.2 alpha:1]];
        
        [pageControlView addSubview:self.pageControl];
        [myCellView addSubview:pageControlView];

        
        // set border remove
        [myCellView.contentView.layer setBorderColor:[UIColor blackColor].CGColor];
        
        
    } else if (indexPath.section == DETAILS) {
        
        switch (indexPath.row)
        {
            case 0:
            {
                TableViewCellIconAndTextView *view = [[TableViewCellIconAndTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
                [view setTitle:[self.businessDetail objectForKey:@"phone"]];
                [view setIcon:[UIImage imageNamed:@"phone"]];
                
                [myCellView addSubview:view];
                
                break;
            }
            case 1:
            {
                NSString *tags = [[[self.businessDetail objectForKey:@"tag"] valueForKey:@"description"] componentsJoinedByString:@", "];
                TableViewCellIconAndTextView *view = [[TableViewCellIconAndTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
                [view setTitle:tags];
                [view setIcon:[UIImage imageNamed:@"tag"]];
                
                [myCellView addSubview:view];
                break;
            }
            case 2:
            {
                NSString *payMethods = [[self.businessDetail objectForKey:@"pay_method"] componentsJoinedByString:@", "];
                TableViewCellIconAndTextView *view = [[TableViewCellIconAndTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
                [view setTitle:payMethods];
                [view setIcon:[UIImage imageNamed:@"card"]];
                
                [myCellView addSubview:view];
                break;
            }
            case 3:
            {
                TableViewCellIconAndTextView *view = [[TableViewCellIconAndTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
                [view setTitle:[NSString stringWithFormat:@"$%@ /person",[self.businessDetail objectForKey:@"price"]]];
                [view setIcon:[UIImage imageNamed:@"money"]];
                
                [myCellView addSubview:view];
                break;
            }
            default:
                break;
        }
    } else if (indexPath.section == DISCOUNT) {
        switch (indexPath.row)
        {
            case 0: // scroll date
            {
                UIScrollView *dateScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)]; // create new scroll view
                
                dateScroll.showsHorizontalScrollIndicator = NO;
                dateScroll.showsVerticalScrollIndicator = NO;
                
                // try to get dates data into an array
                if (!self.dateArray){
                    self.dateArray = [[NSMutableArray alloc] init];
                    for (int i = 0; i < 14; i++) {
                        [self.dateArray addObject:[[self.businessDetail objectForKey:@"discounts"] objectAtIndex:i]]; // get dates
                    }
                }
                
                [dateScroll setContentSize:CGSizeMake(100 * [self.dateArray count], 40)];
                
                
                // add date to dateScroll
                for (int i = 0; i < [self.dateArray count]; i++){
                    
                    CGFloat xOrigin = i * 100;
                    
                    DateScrollViewButton *button = [[DateScrollViewButton alloc] initWithFrame:CGRectMake(xOrigin, 0, 100, 40)];
                    button.tag = i;
                    
                    [self.dateButtons addObject:button];// 按钮加到array里方便重设
                    
                    NSString *timestampString = [[self.dateArray objectAtIndex:i] objectForKey:@"date"];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestampString doubleValue]];
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"MMM dd"];
                    
                    NSString *dateString = [[NSString alloc] init];
                    if(i == 0) {
                        dateString = @"today";
                        [self reloadDiscounts:button];
                    } else if (i == 1) {
                        dateString = @"tomorrow";

                    } else {
                        dateString = [formatter stringFromDate:date];
                    }
                    
                    [button setTitle:dateString forState:UIControlStateNormal];
                    [button addTarget:self
                               action:@selector(reloadDiscounts:)
                     forControlEvents:UIControlEventTouchUpInside];
                    
                    [dateScroll addSubview:button];

                }
                
                [myCellView addSubview:dateScroll];
                break;
            }
            case 1: // detailed discounts for each date
            {
                // try to get dates data into an array
                self.discountArray = [[NSMutableArray alloc] init];
                self.discountArray = [[self.dateArray objectAtIndex:0] objectForKey:@"discount"];
                
                [self loadDiscountScroll:myCellView];
                break;
            }
            default:
                break;
        }
        
        
    } else if (indexPath.section == MAP) { // map
        // 地图
        MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        mapView.showsPointsOfInterest = NO;
        // mapView.delegate = self;
        
        [myCellView addSubview:mapView];
        
        // set region and zoom
        CLLocationCoordinate2D startCoord;
        startCoord.latitude = [[self.businessDetail objectForKey:@"latitude"] doubleValue];
        startCoord.longitude = [[self.businessDetail objectForKey:@"longitude"] doubleValue];
        [mapView setRegion:MKCoordinateRegionMakeWithDistance(startCoord, 200, 200) animated:YES];
        
        // add transparent overlay
        UIView *overlay = [[UIView alloc] initWithFrame:mapView.bounds];
        [overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        [mapView addSubview:overlay];
        
        // add address label
        UILabel *label = [[UILabel alloc] initWithFrame:overlay.bounds];
        label.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
        label.font = [UIFont fontWithName:@"MavenProRegular" size:14];
        label.text = [NSString stringWithFormat:@"%@ %@ %@",[self.businessDetail objectForKey:@"street1"],[self.businessDetail objectForKey:@"street2"],[self.businessDetail objectForKey:@"city"]];
        label.textAlignment = NSTextAlignmentCenter;
        
        [overlay addSubview:label];
        
        // add click event
        UITapGestureRecognizer *awesomeViewSingleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                     action:@selector(redirectMapView:)];
        [label addGestureRecognizer:awesomeViewSingleFingerTap];
        [label setUserInteractionEnabled:YES];
        
    } else if (indexPath.section == DESCRIPTION) {
        [[myCellView textLabel] setText:[self.businessDetail objectForKey:@"description"]];
        myCellView.textLabel.numberOfLines = 0;
        
        NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
        style.minimumLineHeight = 20.f;
        style.maximumLineHeight = 20.f;
        NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};
        myCellView.textLabel.attributedText = [[NSAttributedString alloc] initWithString:[self.businessDetail objectForKey:@"description"]
                                                                              attributes:attributtes];
        
        [myCellView.textLabel sizeToFit];
    } else if (indexPath.section == NOTE) {
      
        // add text
        myCellView.textLabel.numberOfLines = 0;
        
        NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
        style.minimumLineHeight = 20.f;
        style.maximumLineHeight = 20.f;
        NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};
        myCellView.textLabel.attributedText = [[NSAttributedString alloc] initWithString:[self.businessDetail objectForKey:@"note"]
                                                                              attributes:attributtes];
        
        [myCellView.textLabel sizeToFit];
    }
    // 取消每个cell的选择高亮
    myCellView.textLabel.font = [UIFont fontWithName:@"MavenProRegular" size:14];
    myCellView.selectionStyle = UITableViewCellSelectionStyleNone;

    return myCellView;
}

- (void)redirectMapView:(UITapGestureRecognizer *)viewSingleFingerTap {
    MapSingleViewController *mapViewController = [[MapSingleViewController alloc] init];
    
    mapViewController.dict = self.businessDetail;
    
    // pass business detail info to vc
    [self.navigationController pushViewController:mapViewController animated:YES];
}

- (void)reloadDiscounts:(id)sender{
    [self.discountScroll removeFromSuperview]; // clear cell
    self.discountScroll = nil;
    
    DateScrollViewButton *cutSender = sender;
    
    // reset buttons
    for (int i = 0; i < [self.dateButtons count]; i++) {
        DateScrollViewButton *button = [self.dateButtons objectAtIndex:i];
        [button resetButton];
    }
    
    [cutSender selectButton];// change button color

    self.discountArray = [[NSMutableArray alloc] init];
    self.discountArray = [[self.dateArray objectAtIndex:cutSender.tag] objectForKey:@"discount"];
   
    UITableViewCell *cell = [self.scrollView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:DISCOUNT]];//get cell
    
    [self loadDiscountScroll:cell];
}

- (void)loadDiscountScroll:(UITableViewCell *)cell {
    self.discountScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)]; // create new scroll view
    
    self.discountScroll.showsHorizontalScrollIndicator = NO;
    self.discountScroll.showsVerticalScrollIndicator = NO;
    
    [self.discountScroll setContentSize:CGSizeMake(200 * [self.discountArray count], 40)];
    
    
    // add date to dateScroll
    for (int i = 0; i < [self.discountArray count]; i++){
        CGFloat xOrigin = i * 200;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, 0, 200, 40)];
        label.font = [UIFont fontWithName:@"MavenProRegular" size:14];
        [label setText:[NSString stringWithFormat:@"%@-%@ %@",[[self.discountArray objectAtIndex:i] objectForKey:@"start" ],[[self.discountArray objectAtIndex:i] objectForKey:@"end" ],[[self.discountArray objectAtIndex:i] objectForKey:@"discount" ]]];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [self.discountScroll addSubview:label];
    }
    
    [cell addSubview:self.discountScroll]; // add new scroll to cell
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // only banner scroll view can trigger
    if ([scrollView isKindOfClass:[BusinessBannerScrollView class]]) {
        int page = scrollView.contentOffset.x / scrollView.frame.size.width;
        self.pageControl.currentPage = page;
    }
}



@end
