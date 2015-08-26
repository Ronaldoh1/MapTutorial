//
//  ViewController.h
//  MapTutorial
//
//  Created by Ronald Hernandez on 8/26/15.
//  Copyright (c) 2015 Wahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController


@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)addCitiesToMap:(id)sender;

@end

