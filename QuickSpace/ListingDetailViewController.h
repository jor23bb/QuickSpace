//
//  ListingDetailViewController.h
//  QuickSpace
//
//  Created by Gene Oetomo on 1/23/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"
#import "NewListing.h"
#import "Booking.h"

@interface ListingDetailViewController : UIViewController <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NewListing *listing;
@property (nonatomic, strong) Booking *booking;
@property (strong, nonatomic) IBOutlet UIScrollView *picScrollView;


@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceText;
@property (weak, nonatomic) IBOutlet UITextView *locationText;
@property (weak, nonatomic) IBOutlet UILabel *location;

@property (weak, nonatomic) IBOutlet UILabel *amenitiesLabel;
@property (weak, nonatomic) IBOutlet UILabel *amenities;

@property (weak, nonatomic) IBOutlet UILabel *descriptions;
@property (weak, nonatomic) IBOutlet UITextView *descriptionsText;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *bookButton;

//sets the given item a specified distance under another specified item. also sets the x location as to what is specified
+(void) setItemLocation:(UIView *)item withPrev:(UIView *)prev apartBy:(CGFloat)dist atX:(CGFloat)x;

//adds a one-pixel tall dark grey line used to separate different parts of the page
+(void) addSeparatorOnto:(UIView *)view at:(CGFloat)y;

@end
