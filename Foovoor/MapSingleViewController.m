//
//  MapSingleViewController.m
//  Foovoor
//
//  Created by Hao Liu on 11/5/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "MapSingleViewController.h"
#import "MarkerAnnotation.h"
#import "FoovoorViewController.h"

@interface MapSingleViewController () <CLLocationManagerDelegate>


@end

@implementation MapSingleViewController

- (void)viewWillDisappear:(BOOL)animated {
    // nav bar transparent
    [(FoovoorViewController *)self.navigationController becomeTransparent];
}

- (void)viewWillAppear:(BOOL)animated {
    [(FoovoorViewController *)self.navigationController becomeOpaque];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 地图
    self.mapOfView = [[MKMapView alloc] initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, self.view.frame.size.height)];
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
    if (self.dict) {
        [self loadMarkers];
    }
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
    markers = [[NSMutableArray alloc] init];
    
    // 添加marker
    NSString *latitudeString = [self.dict objectForKey:@"latitude"];
    double latitude = [latitudeString doubleValue];
    NSString *longitudeString = [self.dict objectForKey:@"longitude"];
    double longitude = [longitudeString doubleValue];
    
    CLLocationCoordinate2D coordinate = {.latitude = latitude, .longitude = longitude}; // 初始化marker
    MarkerAnnotation *marker = [[MarkerAnnotation alloc] initWithLocation:coordinate];
    
    [self.mapOfView addAnnotation:marker];

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

@end
