//
//  MapViewController.m
//  Foovoor
//
//  Created by Hao Liu on 10/22/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "MarkerAnnotation.h"
#import "HomeViewController.h"
#import "PanelViewOnMap.h"
#import "BusinessDetailViewController.h"

@interface MapViewController () <CLLocationManagerDelegate>


@end

@implementation MapViewController

- (void)viewDidAppear:(BOOL)animated {
    [self reloadView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self changeMapType];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // set title
    self.navigationController.navigationBar.topItem.title = @"Map";
    
    // load data
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    self.array = [userInfo valueForKey:@"homeArray"];

    // 地图
    self.mapOfView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.mapOfView.showsPointsOfInterest = NO;
    self.mapOfView.delegate = self;
    
    [self.view addSubview:self.mapOfView];
    
    // location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [self.locationManager startUpdatingLocation]; // 开始更新当前位置信息
    [self.locationManager setPausesLocationUpdatesAutomatically:YES]; // 允许自动停止更新位置信息
    
    // load markers
    if (self.array) {
        [self loadMarkers];
    }
}

- (void)reloadView {
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.oneLocation = nil; // remove current position info
    [self viewDidLoad];
}

// 收到当前位置更新的消息...
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    
    CLLocationCoordinate2D coord = {.latitude = currentLocation.coordinate.latitude, .longitude =  currentLocation.coordinate.longitude};
    MKCoordinateSpan span = {.latitudeDelta =  0.01, .longitudeDelta =  0.01};
    MKCoordinateRegion region = {coord, span};
    
    if (!self.oneLocation) { // 获得唯一位置了
        [self.mapOfView setRegion:region]; // 地图居中在当前位置
        self.oneLocation = currentLocation;
    }
    
    [self.mapOfView setShowsUserLocation:YES];
}

// 画markers 和 scroll
- (void)loadMarkers {
    // 新建卷动
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 5.0 * 3.4, self.view.frame.size.width, self.view.frame.size.height/5)];
    scroll.delegate = self;
    [self.view insertSubview:scroll aboveSubview:self.mapOfView];
    
    // 卷动开启翻页
    scroll.pagingEnabled = YES;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.alwaysBounceVertical = NO;
    
    // 重新设置卷动窗口宽度
    scroll.contentSize = CGSizeMake(self.view.frame.size.width * [self.array count], scroll.frame.size.height);
    
    markers = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.array count]; i++) {
        NSDictionary *dict = [self.array objectAtIndex:i];
        // 添加marker
        NSString *latitudeString = [dict objectForKey:@"latitude"];
        double latitude = [latitudeString doubleValue];
        NSString *longitudeString = [dict objectForKey:@"longitude"];
        double longitude = [longitudeString doubleValue];
        
        CLLocationCoordinate2D coordinate = {.latitude = latitude, .longitude = longitude}; // 初始化marker
        MarkerAnnotation *marker = [[MarkerAnnotation alloc] initWithLocation:coordinate];
        
        marker.tag = i;
        
        [self.mapOfView addAnnotation:marker];
        // 添加marker到model中
        [markers addObject:marker];
        
        // 添加scroll image
        CGFloat xOrigin = i * self.view.frame.size.width + 15;
        
        PanelViewOnMap *awesomeView = [[PanelViewOnMap alloc] initWithFrame:CGRectMake(xOrigin, 0, self.view.frame.size.width - 30, scroll.frame.size.height)];

        [awesomeView setTitle:[dict objectForKey:@"name"]];
        
        NSString *tags = [[[dict objectForKey:@"tag"] valueForKey:@"description"] componentsJoinedByString:@", "];
        [awesomeView setTitle2:tags];

        [awesomeView setImage:[dict objectForKey:@"photo"]];
        
        [scroll addSubview:awesomeView];
        
        // set awesome view click
        UITapGestureRecognizer *awesomeViewSingleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                     action:@selector(redirectBusinessDetailView:)];
        [awesomeView addGestureRecognizer:awesomeViewSingleFingerTap];
        awesomeView.tag = [[dict objectForKey:@"id"] intValue];
        [awesomeView setUserInteractionEnabled:YES];
    }
}

- (void)redirectBusinessDetailView:(UITapGestureRecognizer *)viewSingleFingerTap {
    BusinessDetailViewController *businessDetailViewController = [[BusinessDetailViewController alloc] init];
    [businessDetailViewController setBusinessID:viewSingleFingerTap.view.tag];
    
    // find the detail info
    NSMutableDictionary *businessDetailInfo = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [self.array count]; i++) {
        if ([[[self.array objectAtIndex:i] objectForKey:@"id"] intValue] == viewSingleFingerTap.view.tag) {
            businessDetailInfo = [self.array objectAtIndex:i];
        }
    }
    
    // pass business detail info to vc
    [businessDetailViewController setBusinessDetail:businessDetailInfo];
    [self.navigationController pushViewController:businessDetailViewController animated:YES];
}

// 卷动了...
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    MarkerAnnotation *targetMarker = (MarkerAnnotation *)[markers objectAtIndex:page];
    // 以点击的marker为中心居中地图
    CLLocationCoordinate2D coord = {.latitude = targetMarker.coordinate.latitude, .longitude = targetMarker.coordinate.longitude};
    [self.mapOfView setCenterCoordinate:coord animated:YES]; // 地图居中在当前位置
}

/*
// marker 定制
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[markerAnnotation class]]) {
        markerAnnotation *marker = (markerAnnotation *)annotation;
        
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"Marker"];
        
        if (annotationView == nil) {
            annotationView = marker.annotationView;
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    } else {
        return nil;
    }
 
}
*/

// 点击marker
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)marker
{
    [self.mapOfView deselectAnnotation:marker.annotation animated:YES];
    
    if ([marker.annotation isKindOfClass:[MarkerAnnotation class]]) {
        MarkerAnnotation *m = marker.annotation;
        
        // 以点击的marker为中心居中地图
        CLLocationCoordinate2D coord = {.latitude = marker.annotation.coordinate.latitude, .longitude = marker.annotation.coordinate.longitude};
        [self.mapOfView setCenterCoordinate:coord animated:YES]; // 地图居中在当前位置
        // scroll 滚动到具体餐馆
        CGRect frame = scroll.frame;
        frame.origin.x = frame.size.width * m.tag;//滚动到制定餐馆
        frame.origin.y = 0;
        [scroll scrollRectToVisible:frame animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self changeMapType];
}

- (void)clearMarkerAndScroll {
    if (scroll) {
        [scroll removeFromSuperview];
        scroll = nil;
    }
    if (markers) {
        [self.mapOfView removeAnnotations:[self.mapOfView annotations]];
    }
}

- (void)changeMapType {
    [super didReceiveMemoryWarning];
    
    switch (self.mapOfView.mapType) {
        case MKMapTypeStandard:
        {
            _mapOfView.mapType = MKMapTypeHybrid;
            _mapOfView.mapType = MKMapTypeStandard;
        }
            
            break;
        default:
            break;
    }
    
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
