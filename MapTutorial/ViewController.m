//
//  ViewController.m
//  MapTutorial
//
//  Created by Ronald Hernandez on 8/26/15.
//  Copyright (c) 2015 Wahoo. All rights reserved.
//

#import "ViewController.h"
#import "JFMapAnnotation.h"

@interface ViewController ()<MKMapViewDelegate>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self addGestureRecogniserToMapView];

}

- (void)addGestureRecogniserToMapView{

    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(addPinToMap:)];
    lpgr.minimumPressDuration = 0.5; //
    [self.mapView addGestureRecognizer:lpgr];

}

- (void)addPinToMap:(UIGestureRecognizer *)gestureRecognizer
{

    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;

    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];

    JFMapAnnotation *toAdd = [[JFMapAnnotation alloc]init];

    toAdd.coordinate = touchMapCoordinate;
    toAdd.subtitle = @"Subtitle";
    toAdd.title = @"Title";

    [self.mapView addAnnotation:toAdd];

}

- (IBAction)addCitiesToMap:(id)sender{
    //Lets fill this in later

    __block NSArray *annoations;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        annoations = [self parseJSONCities];

        dispatch_async(dispatch_get_main_queue(), ^(void) {

            [self.mapView addAnnotations:annoations];

        });
    });

}

/*
 Convert raw JSON to Objective-C Foundation Objects
 Iterate over each returned object and create a JFMapAnnotationObject from it
 Add each new Annotation to an Array and then return it.
 */
- (NSMutableArray *)parseJSONCities{

    NSMutableArray *retval = [[NSMutableArray alloc]init];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"capitals"
                                                         ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:&error];

    for (JFMapAnnotation *record in json) {

        JFMapAnnotation *temp = [[JFMapAnnotation alloc]init];
        [temp setTitle:[record valueForKey:@"Capital"]];
        [temp setSubtitle:[record valueForKey:@"Country"]];
        [temp setCoordinate:CLLocationCoordinate2DMake([[record valueForKey:@"Latitude"]floatValue], [[record valueForKey:@"Longitude"]floatValue])];
        [retval addObject:temp];

    }

    return retval;
}

@end
