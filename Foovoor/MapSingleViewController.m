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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMap];
    
    // load markers
    if (_dict) {
        [self addMarker];
        [self centerMap];
    }
}

- (void)initMap {
    _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _mapView.showsPointsOfInterest = NO;
    
    [self.view addSubview:_mapView];
}

// 画markers 和 scroll
- (void)addMarker {
    NSString *latitudeString = [_dict objectForKey:@"latitude"];
    double latitude = [latitudeString doubleValue];
    NSString *longitudeString = [_dict objectForKey:@"longitude"];
    double longitude = [longitudeString doubleValue];
    
    CLLocationCoordinate2D coordinate = {.latitude = latitude, .longitude = longitude};
    
    MarkerAnnotation *marker = [[MarkerAnnotation alloc] initWithLocation:coordinate
                                                                    title:[NSString stringWithFormat:@"%@", [_dict objectForKey:@"name"]]
                                                                 subTitle:[NSString stringWithFormat:@"%@ %@ %@", [_dict objectForKey:@"street1"],[_dict objectForKey:@"city"],[_dict objectForKey:@"postcode"]]];
    [marker setTag:[[_dict objectForKey:@"id"] intValue]];
    [marker setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [_dict objectForKey:@"photo"]]]];
    
    [_mapView addAnnotation:marker];
    
    [_mapView selectAnnotation:marker animated:YES]; // show callout
}

- (void)centerMap {
    if (_dict) {
        CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake([[_dict objectForKey:@"latitude"] floatValue], [[_dict objectForKey:@"longitude"] floatValue]);
        
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 500, 500)];
        [_mapView setRegion:adjustedRegion animated:YES];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Marker"];
    if ([annotation isKindOfClass:[MarkerAnnotation class]]) {
        
        MKPinAnnotationView *pinAnnotation = (MKPinAnnotationView *)annotationView;
        pinAnnotation.animatesDrop = YES;
        annotationView.canShowCallout = YES;
        
    } else {
        annotationView = nil;
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[MarkerAnnotation class]]) {
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
