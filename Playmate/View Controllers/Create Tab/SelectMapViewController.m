//
//  SelectMapViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/6/22.
//

#import "SelectMapViewController.h"
#import "APIManager.h"
#import "Location.h"

@interface SelectMapViewController () <CLLocationManagerDelegate, UISearchBarDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SelectMapViewController

CLLocationManager *locationManager;
BOOL firstTime;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self fetchDataTester];
    
    self.searchBar.delegate = self;
    
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

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    APIManager *manager = [APIManager new];
    [manager getGeocodedLocation:searchBar.text withCompletion:^(Location *loc, NSError *error) {
        
        if (error == nil) {
            
            if (loc == nil) {
                [self handleAlert:nil withTitle:@"Address not found." andOk:@"Ok"];
            }
            else {
                // extract information from Location object
                // recenter map and put pin
                
                CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake([loc.lat doubleValue], [loc.lng doubleValue]);
                
                MKCoordinateRegion region = MKCoordinateRegionMake(centerCoord, MKCoordinateSpanMake(0.1, 0.1));
                [self.mapView setRegion:region animated:false];
                
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                [annotation setCoordinate:centerCoord];
                [annotation setTitle:loc.locationName];
                [self.mapView addAnnotation:annotation];
                
                // send location back to filters or create view controller
                [self.delegate getSelectedLocation:loc];
            }
            
        } else {
            [self handleAlert:error withTitle:@"Error." andOk:@"Try again."];
        }
        
    }];
    
    [searchBar resignFirstResponder];
}

#pragma mark - Location manager delegate methods

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    [locationManager requestLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
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
