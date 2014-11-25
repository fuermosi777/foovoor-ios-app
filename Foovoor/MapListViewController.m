//
//  MapListViewController.m
//  Foovoor
//
//  Created by Hao Liu on 11/25/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "MapListViewController.h"
#import <MapKit/MapKit.h>
#import "MarkerAnnotation.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BusinessDetailViewController.h"

@interface MapListViewController ()

@end

@implementation MapListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"Map";

    
    [self initMap];
    
    if (self.checkArray) {
        [self addMapAnnotations];
        [self centerMap];
    } else {
        [self.tabBarController setSelectedIndex:1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initMap {
    _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _mapView.showsPointsOfInterest = NO;
    
    [self.view addSubview:_mapView];
}

- (void)addMapAnnotations {
    for (int i = 0; i < [_array count]; i++) {
        NSDictionary *dict = [_array objectAtIndex:i];

        NSString *latitudeString = [dict objectForKey:@"latitude"];
        double latitude = [latitudeString doubleValue];
        NSString *longitudeString = [dict objectForKey:@"longitude"];
        double longitude = [longitudeString doubleValue];
        
        CLLocationCoordinate2D coordinate = {.latitude = latitude, .longitude = longitude};
        
        MarkerAnnotation *marker = [[MarkerAnnotation alloc] initWithLocation:coordinate
                                                                        title:[NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]]
                                                                     subTitle:[NSString stringWithFormat:@"%@ %@ %@", [dict objectForKey:@"street1"],[dict objectForKey:@"city"],[dict objectForKey:@"postcode"]]];
        [marker setTag:[[dict objectForKey:@"id"] intValue]];
        [marker setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dict objectForKey:@"photo"]]]];
        
        [_mapView addAnnotation:marker];
    }
}

- (void)centerMap {
    if ([_array count] != 0) {
        NSDictionary *dict = [_array objectAtIndex:0];
        CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake([[dict objectForKey:@"latitude"] floatValue], [[dict objectForKey:@"longitude"] floatValue]);
        
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 5000, 5000)];
        [_mapView setRegion:adjustedRegion animated:YES];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Marker"];
    if ([annotation isKindOfClass:[MarkerAnnotation class]]) {
        
        MKPinAnnotationView *pinAnnotation = (MKPinAnnotationView *)annotationView;
        pinAnnotation.animatesDrop = YES;

        annotationView.canShowCallout = NO;

    } else {
        annotationView = nil;
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[MarkerAnnotation class]]) {
        _callout = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 60)];
        [_callout setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.9f]];
        
        UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        [avatarView sd_setImageWithURL:[(MarkerAnnotation *)view.annotation imageURL]];
        [avatarView setClipsToBounds:YES];
        [avatarView setContentMode:UIViewContentModeScaleAspectFill];
        [_callout addSubview:avatarView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, self.view.frame.size.width - 70 - 5, 20)];
        [title setText:[NSString stringWithFormat:@"%@",[(MarkerAnnotation *)view.annotation title]]];
        [title setFont:[UIFont fontWithName:@"MavenProRegular" size:14]];
        [title setTextColor:[UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1]];
        [_callout addSubview:title];
        
        UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, self.view.frame.size.width - 70 - 5, 20)];
        [subTitle setText:[NSString stringWithFormat:@"%@",[(MarkerAnnotation *)view.annotation subtitle]]];
        [subTitle setFont:[UIFont fontWithName:@"MavenProRegular" size:12]];
        [subTitle setTextColor:[UIColor grayColor]];
        [_callout addSubview:subTitle];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(redirectToBusinessDetailView:)];
        
        [_callout addGestureRecognizer:tap];
        _callout.tag = [(MarkerAnnotation *)view.annotation tag];
        [_callout setUserInteractionEnabled:YES];

        [self.view addSubview:_callout];
    }
}



- (void)redirectToBusinessDetailView:(UIGestureRecognizer *)tap {
    BusinessDetailViewController *businessDetailViewController = [[BusinessDetailViewController alloc] init];
    [businessDetailViewController setBusinessID:tap.view.tag];
    
    // find the detail info
    NSMutableDictionary *businessDetailInfo = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [_array count]; i++) {
        if ([[[_array objectAtIndex:i] objectForKey:@"id"] intValue] == tap.view.tag) {
            businessDetailInfo = [_array objectAtIndex:i];
        }
    }
    
    // pass business detail info to vc
    [businessDetailViewController setBusinessDetail:businessDetailInfo];
    [self.navigationController pushViewController:businessDetailViewController animated:YES];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [_callout removeFromSuperview];
}

- (BOOL)checkArray {
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    
    _array = [userInfo objectForKey:@"homeArray"];
    
    if (_array) {
        return true;
    } else {
        return false;
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
