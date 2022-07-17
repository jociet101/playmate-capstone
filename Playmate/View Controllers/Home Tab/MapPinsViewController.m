//
//  MapPinsViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/15/22.
//

#import "MapPinsViewController.h"
#import "LocationAnnotation.h"
#import "SessionDetailsViewController.h"
#import "Session.h"
#import "Location.h"

@interface MapPinsViewController () <CLLocationManagerDelegate, UISearchBarDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) Session *selectedSession;
@property (nonatomic, strong) NSArray *sessionList;

@end

@implementation MapPinsViewController

CLLocationManager *pinLocationManager;
BOOL firstTimeGettingLoc;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    self.mapView.delegate = self;
    
    firstTimeGettingLoc = YES;
    
    [CLLocationManager locationServicesEnabled];
    
    //Create location manager
    pinLocationManager = [[CLLocationManager alloc] init];
    [pinLocationManager setDelegate:self];
    [pinLocationManager requestAlwaysAuthorization];
    [pinLocationManager startUpdatingLocation];
    [pinLocationManager startUpdatingHeading];
    pinLocationManager.distanceFilter = kCLDistanceFilterNone;
    pinLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self fetchData];
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
        [self.mapView setRegion:region animated:YES];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
}

#pragma mark - Pin Annotation tasks

- (void)fetchData {
    PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
    query.limit = 20;

    [query orderByAscending:@"occursAt"];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *sessions, NSError *error) {
        if (sessions != nil) {
            self.sessionList = sessions;
            [self addPins];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)addPins {
    
    NSLog(@"session list %@", self.sessionList);
    
    for (Session *session in self.sessionList) {
        Location *location = [session[@"location"] fetchIfNeeded];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([location.lat doubleValue], [location.lng doubleValue]);
        LocationAnnotation *point = [[LocationAnnotation alloc] init];
        point.coordinate = coordinate;
        point.locationName = location.locationName;
        
        NSLog(@"adding %@ pin", point.locationName);
        
        [self.mapView addAnnotation:point];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
     MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        annotationView.canShowCallout = true;
    } else {
        annotationView.annotation = annotation;
    }
    
//    LocationAnnotation *locationAnnotationItem = annotation;

    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:@"pinToDetailsSegue" sender:nil];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    LocationAnnotation *locationAnnotationItem = view.annotation;
    
    if ([locationAnnotationItem.title isEqualToString:@"My Location"]) {
        NSLog(@"Maybe");
        [self.mapView deselectAnnotation:view.annotation animated:NO];
    }
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([segue.identifier isEqualToString:@"pinToDetailsSegue"]) {
         SessionDetailsViewController *vc = segue.destinationViewController;
         vc.sessionDetails = self.selectedSession;
     }
}

@end
