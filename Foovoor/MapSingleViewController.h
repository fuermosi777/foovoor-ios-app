//
//  MapSingleViewController.h
//  Foovoor
//
//  Created by Hao Liu on 11/5/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapSingleViewController : UIViewController <MKMapViewDelegate, UIScrollViewDelegate>

{
    UIScrollView *scroll;
    NSMutableArray *markers;
    
}
@property (strong) CLLocation *oneLocation;
@property (nonatomic, strong) MKMapView *mapOfView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong) NSMutableDictionary *dict;

- (void)loadMarkers;
- (void)clearMarkerAndScroll;

@end
