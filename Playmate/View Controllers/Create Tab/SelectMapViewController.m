//
//  SelectMapViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/6/22.
//

#import "SelectMapViewController.h"
#import "APIManager.h"
#import "Location.h"

@interface SelectMapViewController () <CLLocationManagerDelegate, UISearchBarDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) MKPointAnnotation *selectedLocationAnnotation;

@end

@implementation SelectMapViewController

CLLocationManager *locationManager;
BOOL firstTime;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    
    self.mapView.userInteractionEnabled = YES;
    
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] init];
    [self.longPressGesture addTarget:self action:@selector(didLongPressOnMap:)];
    self.longPressGesture.delegate = self;
    [self.mapView addGestureRecognizer:self.longPressGesture];
    
    self.selectedLocationAnnotation = [[MKPointAnnotation alloc] init];
    
    firstTime = YES;
    
    [CLLocationManager locationServicesEnabled];
    
    //Create location manager
    locationManager = [[CLLocationManager alloc] init];
    //Subscribe to location updates
    [locationManager setDelegate:self];
    //Request always authorization
    [locationManager requestAlwaysAuthorization];
    //Start location updates
    [locationManager startUpdatingLocation];
    //Start heading updates
    [locationManager startUpdatingHeading];
    //Receive all updates
    locationManager.distanceFilter = kCLDistanceFilterNone;
    //Get best possible accuracy
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
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
                [self handleAlert:nil withTitle:@"Current location not found." andOk:@"Ok"];
            }
            else {
                location.locationName = name;
                [self dropPinOnMapAt:coordinate withName:name];
                [self.delegate getSelectedLocation:location];
            }
        } else {
            [self handleAlert:error withTitle:@"Error." andOk:@"Try again."];
        }
    }];
}

- (void)handleAlert:(NSError * _Nullable)error withTitle:(NSString *)title andOk:(NSString *)ok {
    
    NSString *msg = @"Please enter a more specific address.";
    
    if (error != nil) {
        msg = error.localizedDescription;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:ok style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self viewDidLoad];
    }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated: YES completion: nil];
}

#pragma mark - Search bar and geocode

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self geocodeLocationWithSearch:searchBar.text];
    [searchBar resignFirstResponder];
}

- (void)geocodeLocationWithSearch:(NSString *)searchInput {
    APIManager *manager = [APIManager new];
    [manager getGeocodedLocation:searchInput withCompletion:^(Location *loc, NSError *error) {
        
        if (error == nil) {
            
            if (loc == nil) {
                [self handleAlert:nil withTitle:@"Address not found." andOk:@"Ok"];
            }
            else {
                CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake([loc.lat doubleValue], [loc.lng doubleValue]);
                
                [self dropPinOnMapAt:centerCoord withName:loc.locationName];
                [self.delegate getSelectedLocation:loc];
            }
            
        } else {
            [self handleAlert:error withTitle:@"Error." andOk:@"Try again."];
        }
        
    }];
}

- (void)dropPinOnMapAt:(CLLocationCoordinate2D)coordinate withName:(NSString *)locationName {
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.1, 0.1));
    [self.mapView setRegion:region animated:false];
    
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
                [self handleAlert:nil withTitle:@"Current location not found." andOk:@"Ok"];
            }
            else {
                location.locationName = name;
                [self geocodeLocationWithSearch:name];
            }
        } else {
            [self handleAlert:error withTitle:@"Error." andOk:@"Try again."];
        }
    }];
}

#pragma mark - Location manager delegate methods

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    [locationManager requestLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    self.currentLocation = [locations lastObject];
    
    if (firstTime == YES) {
        firstTime = NO;
        
        CLLocation *loc = [locations firstObject];
        
        MKCoordinateRegion region = MKCoordinateRegionMake([loc coordinate], MKCoordinateSpanMake(0.1, 0.1));
        [self.mapView setRegion:region animated:false];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
}

@end
