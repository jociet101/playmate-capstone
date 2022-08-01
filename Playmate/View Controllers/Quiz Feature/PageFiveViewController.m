//
//  PageFiveViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/29/22.
//

#import "PageFiveViewController.h"
#import "HomeViewController.h"
#import "QuizHelpers.h"
#import "QuizResult.h"
#import "APIManager.h"
#import "Location.h"
#import "Constants.h"
#import "Helpers.h"
#import "Strings.h"

@interface PageFiveViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) MKPointAnnotation *selectedLocationAnnotation;
@property (nonatomic, strong) Location *selectedLocation;

@end

@implementation PageFiveViewController

CLLocationManager *originLocationManager;
BOOL firstTimeLoad;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.mapView.userInteractionEnabled = YES;
    
    self.tapGesture = [[UITapGestureRecognizer alloc] init];
    [self.tapGesture addTarget:self action:@selector(didLongPressOnMap:)];
    self.tapGesture.delegate = self;
    [self.mapView addGestureRecognizer:self.tapGesture];
    
    self.selectedLocationAnnotation = [[MKPointAnnotation alloc] init];
    
    firstTimeLoad = YES;
    
    [self initLocationManager];
}

#pragma mark - Location manager and gesture recognizer

- (void)initLocationManager {
    [CLLocationManager locationServicesEnabled];
    
    //Create location manager
    originLocationManager = [[CLLocationManager alloc] init];
    [originLocationManager setDelegate:self];
    [originLocationManager requestAlwaysAuthorization];
    [originLocationManager startUpdatingLocation];
    [originLocationManager startUpdatingHeading];
    originLocationManager.distanceFilter = kCLDistanceFilterNone;
    originLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)didLongPressOnMap:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint locationOnView = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:locationOnView toCoordinateFromView:self.mapView];
    
    Location *location = [Location new];
    location.lat = [NSNumber numberWithDouble:coordinate.latitude];
    location.lng = [NSNumber numberWithDouble:coordinate.longitude];
    
    APIManager *manager = [APIManager new];
    [manager getReverseGeocodedLocation:location withCompletion:^(NSString * _Nonnull name, NSError * _Nonnull error) {
        if (error == nil) {
            if (name == nil) {
                [Helpers handleAlert:nil withTitle:@"Current location not found." withMessage:@"Please enter a more specific address." forViewController:self];
            }
            else {
                location.locationName = name;
                [self geocodeLocationWithSearch:name];
            }
        } else {
            [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
        }
    }];
}

- (void)geocodeLocationWithSearch:(NSString *)searchInput {
    APIManager *manager = [APIManager new];
    [manager getGeocodedLocation:searchInput withCompletion:^(Location *loc, NSError *error) {
        if (error == nil) {
            if (loc == nil) {
                [Helpers handleAlert:nil withTitle:@"Address not found." withMessage:@"Please enter a more specific address." forViewController:self];
            }
            else {
                CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake([loc.lat doubleValue], [loc.lng doubleValue]);
                
                [self dropPinOnMapAt:centerCoord withName:loc.locationName];
                self.selectedLocation = loc;
            }
        } else {
            [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
        }
    }];
}

- (void)dropPinOnMapAt:(CLLocationCoordinate2D)coordinate withName:(NSString *)locationName {
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.02, 0.02));
    [self.mapView setRegion:region animated:YES];
    
    [self.selectedLocationAnnotation setCoordinate:coordinate];
    [self.selectedLocationAnnotation setTitle:locationName];
    [self.mapView addAnnotation:self.selectedLocationAnnotation];
}

#pragma mark - Use current location

- (IBAction)didTapCurrentLocation:(id)sender {
    Location *location = [Location new];
    CLLocationCoordinate2D current = [self.currentLocation coordinate];
    
    location.lat = [NSNumber numberWithDouble:current.latitude];
    location.lng = [NSNumber numberWithDouble:current.longitude];
    
    APIManager *manager = [APIManager new];
    [manager getReverseGeocodedLocation:location withCompletion:^(NSString * _Nonnull name, NSError * _Nonnull error) {
        if (error == nil) {
            if (name == nil) {
                [Helpers handleAlert:nil withTitle:@"Current location not found." withMessage:@"Please enter a more specific address." forViewController:self];
            }
            else {
                location.locationName = name;
                [self geocodeLocationWithSearch:name];
            }
        } else {
            [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
        }
    }];
}

#pragma mark - Location manager delegate methods

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    [originLocationManager requestLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.currentLocation = [locations lastObject];
    
    if (firstTimeLoad == YES) {
        firstTimeLoad = NO;
        CLLocation *loc = [locations firstObject];
        MKCoordinateRegion region = MKCoordinateRegionMake([loc coordinate], MKCoordinateSpanMake(0.1, 0.1));
        [self.mapView setRegion:region animated:YES];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
}

#pragma mark - Done action

- (IBAction)didTapDone:(id)sender {
    PFUser *me = [[PFUser currentUser] fetchIfNeeded];
    NSString *resultObjectId = [me objectForKey:@"quizResult"][0];
    if (resultObjectId != nil) {
        [me removeObjectForKey:@"quizResult"];
        [me saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            QuizResult *result = [PFQuery getObjectOfClass:@"QuizResult" objectId:resultObjectId error:nil];
            [result deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [self saveQuizResult];
            }];
        }];
    } else {
        [self saveQuizResult];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    HomeViewController *vc = [[homeVC viewControllers][0] childViewControllers][0];
    self.delegate = (id)vc;
    [self.delegate quizDoneMessage];
}

- (void)saveQuizResult {
    [QuizResult saveQuizResultWithSports:self.playSportsList
                            andNotSports:self.dontPlaySportsList
                              andGenders:self.gendersList
                                 andAges:self.ageGroupsList
                             andLocation:self.selectedLocation
                          withCompletion:^(BOOL success, NSError * _Nonnull error) {
        if (success) {
            PFUser *me = [[PFUser currentUser] fetchIfNeeded];
            PFQuery *query = [PFQuery queryWithClassName:@"QuizResult"];
            [query whereKey:@"userObjectId" equalTo:me.objectId];
            QuizResult *result = [query getFirstObject];
            [me addObject:result.objectId forKey:@"quizResult"];
            [me saveInBackground];
        } else {
            [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
        }
    }];
}

#pragma mark - Navigation

- (IBAction)didTapClose:(id)sender {
    [QuizHelpers giveCloseWarningforViewController:self];
}

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 }

@end
