//
//  SelectMapViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/6/22.
//

#import "SelectMapViewController.h"
#import "APIManager.h"
#import "Location.h"

@interface SelectMapViewController () <CLLocationManagerDelegate, UISearchBarDelegate>

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
    [manager getGeocodedLocation:searchBar.text WithCompletion:^(Location *loc, NSError *error) {
        
        if (error == nil) {
            
            if (loc == nil) {
                [self handleAlert:nil withTitle:@"Address not found." andOk:@"Ok"];
            }
            else {
                // set location stuff!!!
                // show on map and send back through delegate
                NSLog(@"loc.lng = %@", loc.lng);
                NSLog(@"loc.lat = %@", loc.lat);
                NSLog(@"loc.name = %@", loc.locationName);
            }
            
        } else {
            [self handleAlert:error withTitle:@"Error." andOk:@"Try again."];
        }
        
    }];
    
    [searchBar resignFirstResponder];
}

#pragma mark - Location manager delegate methods

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    NSLog(@"did change authorization");
    [locationManager requestLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    NSLog(@"did update locations");
    
    if (firstTime == YES) {
        firstTime = NO;
        
        CLLocation *loc = [locations firstObject];
        
        MKCoordinateRegion region = MKCoordinateRegionMake([loc coordinate], MKCoordinateSpanMake(0.1, 0.1));
        [self.mapView setRegion:region animated:false];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"location manager failed with error: %@", error.localizedDescription);
}

//- (IBAction)didTapDone:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
