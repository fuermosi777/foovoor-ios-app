//
//  MapListViewController.h
//  Foovoor
//
//  Created by Hao Liu on 11/25/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapListViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) NSArray *array;
@property (strong, nonatomic) UIView *callout;

@end
