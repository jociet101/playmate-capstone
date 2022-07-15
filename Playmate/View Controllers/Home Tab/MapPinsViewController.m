//
//  MapPinsViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/15/22.
//

#import "MapPinsViewController.h"

@interface MapPinsViewController () <CLLocationManagerDelegate, UISearchBarDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation MapPinsViewController

CLLocationManager *pinLocationManager;
BOOL firstTimeGettingLoc;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    
    firstTimeGettingLoc = YES;
    
    [CLLocationManager locationServicesEnabled];
    
    //Create location manager
    pinLocationManager = [[CLLocationManager alloc] init];
    //Subscribe to location updates
    [pinLocationManager setDelegate:self];
    //Request always authorization
    [pinLocationManager requestAlwaysAuthorization];
    //Start location updates
    [pinLocationManager startUpdatingLocation];
    //Start heading updates
    [pinLocationManager startUpdatingHeading];
    //Receive all updates
    pinLocationManager.distanceFilter = kCLDistanceFilterNone;
    //Get best possible accuracy
    pinLocationManager.desiredAccuracy = kCLLocationAccuracyBest;

}

#pragma mark - Location manager delegate methods

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    [pinLocationManager requestLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (firstTimeGettingLoc == YES) {
        firstTimeGettingLoc = NO;
        
        CLLocation *loc = [locations firstObject];
        
        MKCoordinateRegion region = MKCoordinateRegionMake([loc coordinate], MKCoordinateSpanMake(0.1, 0.1));
        [self.mapView setRegion:region animated:false];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
}

//TODO: navigation to session details

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

@end
