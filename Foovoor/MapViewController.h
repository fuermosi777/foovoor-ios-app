//
//  MapViewController.h
//  Foovoor
//
//  Created by Hao Liu on 10/22/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, UIScrollViewDelegate>
{
    UIScrollView *scroll;
    NSMutableArray *markers;

}
@property (strong) CLLocation *oneLocation;
@property (nonatomic, strong) MKMapView *mapOfView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong) NSMutableArray *array;

- (void)loadMarkers;
- (void)clearMarkerAndScroll;

@end
