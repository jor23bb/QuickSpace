//
//  FilterViewController.m
//  QuickSpace
//
//  Created by Tony Wang on 1/27/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@end

@implementation FilterViewController {
    NSNumber *latitude;
    NSNumber *longitude;
    NSMutableArray *spaceType;
    CLLocationManager *locationManager;
}

@synthesize spaceType;
@synthesize restButton;
@synthesize closetButton;
@synthesize officeButton;
@synthesize quietButton;
@synthesize startPicker;
@synthesize endPicker;
@synthesize line1;
@synthesize line2;
@synthesize line3;
@synthesize useCurrLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (useCurrLocation){
        if(locationManager == nil)
            locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        
//        [locationManager requestWhenInUseAuthorization];
        
        [locationManager startMonitoringSignificantLocationChanges];
        NSLog(@"using user location");
    }
    
    NSNumber *space = [NSNumber numberWithBool:NO];
    NSNumber *closet = [NSNumber numberWithBool:NO];
    NSNumber *office = [NSNumber numberWithBool:NO];
    NSNumber *quiet = [NSNumber numberWithBool:NO];
    
    spaceType = [NSMutableArray arrayWithObjects:space, closet, office, quiet, nil];
    
    CGRect frame = startPicker.frame;
    frame.size.height = 83;
    frame.size.height = 239;
    [startPicker setFrame:frame];
    [endPicker setFrame:frame];
    
    //reorganize vertical line separators
    frame = line1.frame;
    frame.origin.x = line1.superview.frame.size.width/4;
    line1.frame = frame;
    frame = line2.frame;
    frame.origin.x = line2.superview.frame.size.width/2;
    line2.frame = frame;
    frame = line3.frame;
    frame.origin.x = line3.superview.frame.size.width*3/4;
    line3.frame = frame;
    
    CGFloat viewX = self.timePickerContainer.frame.size.width;
    CGFloat viewY = self.timePickerContainer.frame.size.height;
    startPicker.frame = CGRectMake(0, 0, viewX, viewY/2);
    startPicker.transform = CGAffineTransformMakeScale(.7, .7);
    endPicker.frame = CGRectMake(0, viewY/2, viewX, viewY/2);
    endPicker.transform = CGAffineTransformMakeScale(.7, .7);
    endPicker.minimumDate = startPicker.date; 
}

// End time cannot be less than start time
- (IBAction)limitEndTime:(UIDatePicker *)sender {
    endPicker.minimumDate = startPicker.date;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Remove the keyboard after typing
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    [locationManager stopUpdatingLocation];
//    NSDate* eventDate = location.timestamp;
//    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
//    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
        longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
        NSLog(@"Latitude is: %f", location.coordinate.latitude);
//    }
}

// spacetype buttons
- (IBAction)restSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}

- (IBAction)closetSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}

- (IBAction)officeSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}

- (IBAction)quietSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowAvailableListings"]) {
        
        // Set start and end time
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:startPicker.date forKey:@"startTime"];
        [defaults setObject:endPicker.date forKey:@"endTime"];
        
        // Set the listing type
        spaceType = [[NSMutableArray alloc]init];
        
        if (restButton.selected)[spaceType addObject:[NSNumber numberWithInt:rest]];
        if (closetButton.selected)[spaceType addObject:[NSNumber numberWithInt:closet]];
        if (officeButton.selected)[spaceType addObject:[NSNumber numberWithInt:office]];
        if (quietButton.selected)[spaceType addObject:[NSNumber numberWithInt:quiet]];
        [defaults setObject:spaceType forKey:@"spaceTypes"];
        
        if(useCurrLocation){
            [defaults setObject:latitude forKey:@"latitude"];
            [defaults setObject:longitude forKey:@"longitude"];
        }
    }
}

@end
