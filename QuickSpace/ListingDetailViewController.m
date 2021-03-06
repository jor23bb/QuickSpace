//
//  ListingDetailViewController.m
//  QuickSpace
//
//  Created by Gene Oetomo on 1/23/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "ListingDetailViewController.h"
#import "BookingConfirmationViewController.h"
#import <Parse/Parse.h>
#import "Booking.h"
#import "modalPictureViewController.h"

@interface ListingDetailViewController () {
    Booking *booking;
    NSMutableArray *images;
}

@end

@implementation ListingDetailViewController

@synthesize picScrollView;
@synthesize titleLabel;
@synthesize listing;
@synthesize typeLabel;
@synthesize priceLabel;
@synthesize priceText;
@synthesize locationText;
@synthesize location;
@synthesize amenities;
@synthesize bookButton;
@synthesize ratingLabel;
@synthesize amenitiesLabel;
@synthesize descriptionsText;
@synthesize booking;
@synthesize scrollView;
@synthesize descriptions;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    picScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    picScrollView.pagingEnabled = YES;
    for(int i = 0; i < listing.images.count; i++){
        CGFloat myOrigin = i*self.view.frame.size.width;
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(myOrigin, 0, self.view.frame.size.width, self.view.frame.size.width)];
        image.image = [UIImage imageWithData:[[listing.images objectAtIndex:i] getData]];
        
        picScrollView.delegate = self;
        [picScrollView addSubview:image];
    }
    
    picScrollView.contentSize = CGSizeMake(self.view.frame.size.width * listing.images.count, self.view.frame.size.width);
    

    
    titleLabel.text = listing.title;
    int rating = listing.ratingValue;
    if (rating == 0) {
        ratingLabel.text = @"No Ratings Yet";
    } else {
        ratingLabel.text = [NSString stringWithFormat:@"Rating: %d/3", rating];
    }
//    
//    UITapGestureRecognizer *picClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandPics:)];
//    [picClick setDelegate:self];
//    [image addGestureRecognizer:picClick];
//    
    //set scrollView
    scrollView.frame = self.view.frame;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    CGRect viewFrame = scrollView.frame;
    CGFloat mid = viewFrame.size.width/2;
    
    //set image location
    CGRect frame = picScrollView.frame;
    frame.origin.y = 0;
    picScrollView.frame = frame;
    
    //set title
    frame = titleLabel.frame;
    frame.origin.x = mid - frame.size.width/2;
    frame.origin.y = picScrollView.frame.origin.y + picScrollView.frame.size.height + 10;
    titleLabel.frame = frame;
    
    //set type
    typeLabel.numberOfLines = 0;
    typeLabel.text = [listing typesToString];
    CGSize labelSize = [typeLabel.text sizeWithAttributes:@{NSFontAttributeName:typeLabel.font}];
    typeLabel.frame = CGRectMake(mid - typeLabel.frame.size.width/2, typeLabel.frame.origin.y, typeLabel.frame.size.width, labelSize.height);
    [ListingDetailViewController setItemLocation:typeLabel withPrev:titleLabel apartBy:5 atX:typeLabel.frame.origin.x];
    
    //set rating
    ratingLabel.numberOfLines = 0;
    labelSize = [ratingLabel.text sizeWithAttributes:@{NSFontAttributeName:ratingLabel.font}];
    ratingLabel.frame = CGRectMake(mid - ratingLabel.frame.size.width/2, ratingLabel.frame.origin.y, ratingLabel.frame.size.width, labelSize.height);
    [ListingDetailViewController setItemLocation:ratingLabel withPrev:typeLabel apartBy:5 atX:ratingLabel.frame.origin.x];
    [ListingDetailViewController addSeparatorOnto:scrollView at:ratingLabel.frame.origin.y + ratingLabel.frame.size.height + 10];
    
    //set price
    priceText.text = [NSString stringWithFormat:@"$%d", listing.price];
    [ListingDetailViewController setItemLocation:priceLabel withPrev:ratingLabel apartBy:15 atX:priceLabel.frame.origin.x];
    [ListingDetailViewController setItemLocation:priceText withPrev:ratingLabel apartBy:15 atX:mid];
    
    //set location
    locationText.text = listing.address;
    locationText.selectable = NO;
    locationText.editable = NO;
    locationText.scrollEnabled = NO;
    locationText.textContainer.lineFragmentPadding = 0;
    locationText.textContainerInset = UIEdgeInsetsZero;
    CGFloat fixedWidth = locationText.frame.size.width;
    CGSize newSize = [locationText sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    frame = locationText.frame;
    frame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    locationText.frame = frame;
    locationText.backgroundColor = [UIColor clearColor];
    [ListingDetailViewController setItemLocation:location withPrev:priceText apartBy:10 atX:location.frame.origin.x];
    [ListingDetailViewController setItemLocation:locationText withPrev:priceText apartBy:10 atX:mid];
//    [ListingDetailViewController addSeparatorOnto:scrollView at:locationLabel.frame.size.height + locationLabel.frame.origin.y];
    
    //set amenities
    amenitiesLabel.text = [listing amenitiesToString];
    amenitiesLabel.numberOfLines = 0;
    labelSize = [amenitiesLabel.text sizeWithAttributes:@{NSFontAttributeName:amenitiesLabel.font}];
    amenitiesLabel.frame = CGRectMake(mid, amenitiesLabel.frame.origin.y, amenitiesLabel.frame.size.width, labelSize.height);
    [ListingDetailViewController setItemLocation:amenities withPrev:locationText apartBy:10 atX:amenities.frame.origin.x];
    [ListingDetailViewController setItemLocation:amenitiesLabel withPrev:locationText apartBy:10 atX:mid];
//    [ListingDetailViewController addSeparatorOnto:scrollView at:amenitiesLabel.frame.origin.y + amenitiesLabel.frame.size.height + 3];
    
    //set other descriptions
    //update the description
    NSString *descripString = listing.information;
    if (descripString.length == 0){
        descriptionsText.text = @"No Additional Description";
    } else {
        descriptionsText.text = descripString;
    }
    descriptionsText.textContainer.lineFragmentPadding = 0;
    descriptionsText.textContainerInset = UIEdgeInsetsZero;
    descriptionsText.selectable = NO;
    descriptionsText.editable = NO;
    descriptionsText.scrollEnabled = NO;
    fixedWidth = descriptionsText.frame.size.width;
    newSize = [descriptionsText sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    frame = descriptionsText.frame;
    frame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    descriptionsText.frame = frame;
    descriptionsText.backgroundColor = [UIColor clearColor];
    [ListingDetailViewController setItemLocation:descriptions withPrev:amenitiesLabel apartBy:10 atX:descriptions.frame.origin.x];
    [ListingDetailViewController setItemLocation:descriptionsText withPrev:descriptions apartBy:5 atX:mid - frame.size.width/2];
    
    //resize button
    frame = bookButton.frame;
    frame.origin.x = 0;
    frame.size.width = viewFrame.size.width;
    bookButton.frame = frame;
    
    //if the page is longer than one page, move the book button down
    CGFloat endOfPage = descriptionsText.frame.origin.y + descriptionsText.frame.size.height + 10 + bookButton.frame.size.height;
    CGFloat bottomOfView = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
    frame = bookButton.frame;
    frame.origin.x = mid - frame.size.width/2;
    if (endOfPage > bottomOfView){
        frame.origin.y = descriptionsText.frame.origin.y + descriptionsText.frame.size.height + 10;
        bookButton.frame = frame;
    } else {
        frame.origin.y = bottomOfView - bookButton.frame.size.height;
        bookButton.frame = frame;
    }
    
    //resize scrollview frame
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, bookButton.frame.size.height + bookButton.frame.origin.y);
}

+ (void) setItemLocation:(UIView *)item withPrev:(UILabel *)prev apartBy:(CGFloat)dist atX:(CGFloat)x
{
    CGRect frame = item.frame;
    frame.origin.y = prev.frame.origin.y + prev.frame.size.height + dist;
    frame.origin.x = x;
    item.frame = frame;
}

+ (void) addSeparatorOnto:(UIView *)view at:(CGFloat)y
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(4, y, view.frame.size.width - 8, 1)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [view addSubview:line];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)bookButton:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    PFUser *currentUser = [PFUser currentUser];
    NSDate *startTime = [defaults objectForKey:@"startTime"];
    NSDate *endTime = [defaults objectForKey:@"endTime"];
    
    if (currentUser == listing.lister){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You can't book your own listing!" message:@""delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    } else {
        booking = [Booking object];
        booking.startTime = startTime;
        booking.endTime = endTime;
        booking.guest = currentUser;
        booking.owner = listing.lister;
        booking.rating = 0;
        booking.listing = listing;
        [booking saveInBackground];
        [booking pinWithName:@"Booking"];
        [self performSegueWithIdentifier:@"ShowBookingConfirmation" sender:self];
    }
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

// Start a slide show of pictures
-(void) expandPics:(UITapGestureRecognizer *)sender{
    [self performSegueWithIdentifier:@"modalPics" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowBookingConfirmation"]){
        BookingConfirmationViewController *destViewController = segue.destinationViewController;
        destViewController.booking = booking;
    } else if ([segue.identifier isEqualToString:@"modalPics"]){
        modalPictureViewController *destViewController = segue.destinationViewController;
        destViewController.imageFiles = listing.images;
    }
}


@end
