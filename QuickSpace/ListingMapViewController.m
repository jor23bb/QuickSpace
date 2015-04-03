//
//  ListingMapViewController.m
//  QuickSpace
//
//  Created by Tony Wang on 3/1/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "ListingMapViewController.h"
#import "ListingDetailViewController.h"

@interface ListingMapViewController ()

@end

@implementation ListingMapViewController{
//    CLLocationManager *locationManager;
}

@synthesize myMapView;
@synthesize listings;
@synthesize showListViewButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Pretend it's a modal view
    self.navigationItem.hidesBackButton = YES;
    myMapView.delegate = self;
    
    // Add pins to map that met previous search criteria
    for (NewListing *listing in listings){
        PFGeoPoint *gp = listing.location;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(gp.latitude, gp.longitude);
        customAnnotation *point = [[customAnnotation alloc]initWithTitle:listing.title Location:coordinate];
        [point setSubTitle:[NSString stringWithFormat:@"Price: $%d/hour", listing.price]];
        [point setListing:listing];
        [myMapView addAnnotation:point];
    }
    [myMapView showAnnotations:myMapView.annotations animated:YES];
    
//    if(locationManager == nil)
//        locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    [locationManager startMonitoringSignificantLocationChanges];
//    
}

// Delegate method from the CLLocationManagerDelegate protocol.
//- (void)locationManager:(CLLocationManager *)manager
//     didUpdateLocations:(NSArray *)locations {
//    // If it's a relatively recent event, turn off updates to save power.
//    CLLocation* location = [locations lastObject];
//    NSDate* eventDate = location.timestamp;
//    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
//    if (abs(howRecent) < 15.0) {
//        // If the event is recent, do something with it.
//        NSLog(@"latitude %+.6f, longitude %+.6f\n",
//              location.coordinate.latitude,
//              location.coordinate.longitude);
//    }
//}

-(MKAnnotationView *)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if([annotation isKindOfClass:[customAnnotation class]]){
        customAnnotation *myPin = (customAnnotation *)annotation;
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"customAnnotation"];
        
        if (annotationView == nil)
            annotationView = myPin.annotationView;
        else
            annotationView.annotation = annotation;
        
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return annotationView;
    }
    return nil;
}

// If callout accessory was clicked go to corresponding Listing page
-(void)mapView:(MKMapView*) mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    [self performSegueWithIdentifier:@"toDetailViewController" sender:view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Go back to the list view
- (IBAction)dismissView:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toDetailViewController"]){
        ListingDetailViewController* destViewController = segue.destinationViewController;
        MKAnnotationView *annotationView = sender;
        customAnnotation *myAnnotation = annotationView.annotation;
        
        destViewController.listing = myAnnotation.listing;
    }
}

@end
